require 'uri'

module ManageIQ::Providers
  module Hawkular
    class Inventory::Parser::MiddlewareManager < ManagerRefresh::Inventory::Parser
      include ::Hawkular::ClientUtils

      def initialize
        super
        @cache = {}
      end

      def parse
        fetch_domains
        fetch_middleware_servers
        fetch_server_entities
        fetch_availabilities
      end

      def fetch_middleware_servers
        collector.all_resources.each do |server|
          server_from_db = persister.middleware_servers.find_or_build(server.path)
          parse_base_item(server, server_from_db)

          attributes = {
            :name      => server.prepared_name,
            :type_path => URI.escape(server.type_path),
            :hostname  => server.hostname,
            :product   => server.product
          }

          case server.product
          when /wildfly/i
            attributes[:type] = 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly'
          when /server/i
            attributes[:type] = 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerEap'
          end

          server_from_db.assign_attributes(attributes)

          if server.in_container?
            container = Container.find_by(:backing_ref => "docker://#{server.container_url}")
            server_from_db.lives_on = container if container
          else
            # Add the association to vm instance if there is any
            host = find_host_by_bios_uuid(server.possible_machine_ids)
            server_from_db.lives_on = host if host
          end

          next unless server.kind_of?(Entities::DomainWildflyServer)
          server_from_db.middleware_server_group = persister.middleware_server_groups.find(@cache.dig(:server_groups, server.properties[:server_group]))
        end
      end

      def fetch_server_entities
        collector.all_resources.each do |server|
          server.relationships.all.each do |entity|
            case entity
            when Entities::Deployment
              inventory_object = persister.middleware_deployments.find_or_build(entity.path)
            when Entities::Datasource
              inventory_object = persister.middleware_datasources.find_or_build(entity.path)

              inventory_object.properties = (entity.config.dig(:config, :value) || {}).except('Username', 'Password')
            when Entities::JmsQueue, Entities::JmsTopic
              inventory_object = persister.middleware_messagings.find_or_build(entity.path)

              type_path = ::Hawkular::Inventory::CanonicalPath.parse(entity.type_path)
              inventory_object.messaging_type = URI.decode(type_path.resource_type_id)

              inventory_object.properties = (entity.config.dig(:config, :value) || {}).except('Username', 'Password')
            else
              next
            end

            parse_base_item(entity, inventory_object)

            inventory_object.name = entity.name
            inventory_object.middleware_server = persister.middleware_servers.lazy_find(server.path)

            if inventory_object.respond_to?(:middleware_server_group=)
              inventory_object.middleware_server_group = persister.middleware_server_groups.lazy_find(server.properties[:server_group])
            end
          end
        end
      end

      def fetch_domains
        collector.all_resources.each do |server|
          domains = server.relationships.domain_wildfly_hosts

          next unless domains.any?

          domains.each do |domain|
            parsed_domain = persister.middleware_domains.find_or_build(domain.path)

            parse_base_item(domain, parsed_domain)

            parsed_domain.name = domain.name
            parsed_domain.type_path = domain.type_path

            fetch_server_groups_for(domain)
          end
        end
      end

      def fetch_server_groups_for(domain)
        collector.all_resources.each do |server|
          groups = server.relationships.wildfly_domain_server_groups

          next unless groups.any?

          groups.each do |server_group|
            server_group_from_db = persister.middleware_server_groups.find_or_build(server_group.path)
            parse_base_item(server_group, server_group_from_db)

            server_group_from_db.assign_attributes(
              :name      => server_group.name,
              :type_path => server_group.type_path,
              :profile   => server_group.properties[:profile]
            )

            @cache[:server_groups] ||= {}
            @cache[:server_groups][server_group.name] = server_group.path

            server_group_from_db.middleware_domain = persister.middleware_domains.find(domain.path)
          end
        end
      end

      def fetch_availabilities
        feeds_of_interest = persister.middleware_servers.to_a.map(&:feed)
        fetch_server_availabilities(feeds_of_interest)
        fetch_deployment_availabilities(feeds_of_interest)
        fetch_domain_availabilities(feeds_of_interest)
      end

      private

      def parse_base_item(item, inventory_object)
        inventory_object.ems_ref = item.path
        inventory_object.nativeid = item.id
        inventory_object.properties = item.properties
        inventory_object.feed = item.feed
      end

      def find_host_by_bios_uuid(*machine_ids)
        identity_systems = machine_ids.flatten.reject(&:blank?).map(&:downcase)
        return if identity_systems.empty?

        if identity_systems.any?
          Vm.find_by(:uid_ems => identity_system, :type => uuid_provider_types)
        end
      end

      def uuid_provider_types
        'ManageIQ::Providers::Redhat::InfraManager::Vm'
      end

      def process_server_availability(server_state, availability = nil)
        avail = availability.try(:[], 'value') || 'unknown'
        [avail, avail == 'up' ? server_state : avail]
      end

      def process_deployment_availability(availability = nil)
        process_availability(availability, 'up' => 'Enabled', 'down' => 'Disabled')
      end

      def process_domain_availability(availability = nil)
        process_availability(availability, 'up' => 'Running', 'down' => 'Stopped')
      end

      def process_availability(availability, translation = {})
        translation.fetch(availability.try(:[], 'value').try(:downcase), 'Unknown')
      end

      def fetch_deployment_availabilities(feeds)
        collection = persister.middleware_deployments
        fetch_availabilities_for(feeds, collection, collection.model_class::AVAIL_TYPE_ID) do |deployment, availability|
          deployment.status = process_deployment_availability(availability.try(:[], 'data').try(:first))
        end
      end

      def fetch_server_availabilities(feeds)
        collection = persister.middleware_servers
        fetch_availabilities_for(feeds, collection, collection.model_class::AVAIL_TYPE_ID) do |server, availability|
          props = server.properties

          props['Availability'], props['Calculated Server State'] =
            process_server_availability(props['Server State'], availability.try(:[], 'data').try(:first))
        end
      end

      def fetch_domain_availabilities(feeds)
        collection = persister.middleware_domains
        fetch_availabilities_for(feeds, collection, collection.model_class::AVAIL_TYPE_ID) do |domain, availability|
          domain.properties['Availability'] =
            process_domain_availability(availability.try(:[], 'data').try(:first))
        end
      end

      def fetch_availabilities_for(feeds, collection, metric_type_id)
        resources_by_metric_id = {}
        metric_id_by_resource_path = {}

        feeds.each do |feed|
          status_metrics = collector.metrics_for_metric_type(feed, metric_type_id)
          status_metrics.each do |status_metric|
            status_metric_path = ::Hawkular::Inventory::CanonicalPath.parse(status_metric.path)
            # By dropping metric_id from the canonical path we end up with the resource path
            resource_path = ::Hawkular::Inventory::CanonicalPath.new(
              :tenant_id    => status_metric_path.tenant_id,
              :feed_id      => status_metric_path.feed_id,
              :resource_ids => status_metric_path.resource_ids
            )
            metric_id_by_resource_path[URI.decode(resource_path.to_s)] = status_metric.hawkular_metric_id
          end
        end

        collection.each do |item|
          yield item, nil

          path = URI.decode(item.try(:resource_path_for_metrics) ||
            item.try(:model_class).try(:resource_path_for_metrics, item) ||
            item.try(:ems_ref) ||
            item.manager_uuid)
          next unless metric_id_by_resource_path.key? path
          metric_id = metric_id_by_resource_path[path]
          resources_by_metric_id[metric_id] = [] unless resources_by_metric_id.key? metric_id
          resources_by_metric_id[metric_id] << item
        end

        unless resources_by_metric_id.empty?
          availabilities = collector.raw_availability_data(resources_by_metric_id.keys,
                                                           :limit => 1, :order => 'DESC')
          availabilities.each do |availability|
            resources_by_metric_id[availability['id']].each do |resource|
              yield resource, availability
            end
          end
        end
      end
    end
  end
end

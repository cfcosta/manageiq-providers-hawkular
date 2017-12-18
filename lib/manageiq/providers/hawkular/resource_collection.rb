require 'generic_view_mapper'
require_relative 'entity_mapper'
require_relative 'entities/middleware_server'
require_relative 'entities/wildfly_server'

module ManageIQ
  module Providers
    module Hawkular
      class ResourceCollection
        attr_reader :data

        def initialize(resources)
          @data = resources
        end

        def entities
          @entities ||= data.flat_map do |d|
            data = EntityMapper.map(d)
            GenericViewMapper.matcher.find_entity_for(data).new(data)
          end
        end

        def prepared
          servers = entities.select { |x| x.kind_of?(Entities::MiddlewareServer) }
          resources = (entities - servers).group_by(&:feed)

          servers.each do |server|
            server.relationships = resources[server.feed]
            ap resources[server.feed].select { |x| x.is_a? Entities::Datasource }.map{ |x| x.original_attributes }

            resources[server.feed]
              .inject({}) { |accum, el| accum.merge(el.properties) }
              .merge!(server.properties)
          end

          servers
        end
      end
    end
  end
end

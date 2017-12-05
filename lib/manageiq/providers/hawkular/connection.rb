require 'hawkular/hawkular_client'
require_relative 'resource_collection'

module ManageIQ
  module Providers
    module Hawkular
      class Connection
        include ::Hawkular::ClientUtils

        attr_reader :client

        def initialize(client = connect)
          @client = client
        end

        def connect
          ::Hawkular::Client.new(
            :entrypoint  => 'http://localhost:8080',
            :credentials => { :username => 'jdoe', :password => 'password' },
            :options     => { :tenant => 'hawkular' }
          )
        end

        def fetch_all_resources
          feeds = client.inventory.list_feeds

          feeds.flat_map do |feed|
            resources =  client.inventory.list_resource_types(feed)
              .map { |x| x.instance_variable_get(:@_hash)['id'] }
              .flat_map { |x| client.inventory.list_resources_for_type(path_for(feed, x), :fetch_properties => true) }

            ResourceCollection.new(resources).prepared
          end
        end

        private

        def path_for(feed, type)
          ::Hawkular::Inventory::CanonicalPath.new(
            :feed_id          => hawk_escape_id(feed),
            :resource_type_id => hawk_escape_id(type)
          )
        end
      end
    end
  end
end

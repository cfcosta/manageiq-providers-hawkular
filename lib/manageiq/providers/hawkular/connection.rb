require 'hawkularclient'
require_relative 'resource_collection'

module ManageIQ
  module Providers
    module Hawkular
      class Connection
        def client(client_class = ::Hawkular::Client)
          @client ||= client_class.new(
            entrypoint: 'http://localhost:8080',
            credentials: { username: 'jdoe', password: 'password' },
            options: { tenant: 'hawkular' }
          )
        end

        def get_all_resources
          feeds = client.inventory.list_feeds

          feeds.map do |feed|
            resources = client.inventory
              .list_resources_for_feed(feed, true)
            ResourceCollection.new(resources).prepared
          end.flatten
        end
      end
    end
  end
end

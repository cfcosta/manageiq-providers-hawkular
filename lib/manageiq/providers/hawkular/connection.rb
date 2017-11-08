require 'hawkularclient'
require_relative 'resource_collection'

module ManageIQ
  module Providers
    module Hawkular
      class Connection
        def client(client_class = ::Hawkular::Client)
          @client ||= client_class.new(
            :entrypoint  => 'http://localhost:8080',
            :credentials => { :username => 'jdoe', :password => 'password' },
            :options     => { :tenant => 'hawkular' }
          )
        end

        def fetch_all_resources
          ResourceCollection.new(client.inventory.root_resources).prepared
        end
      end
    end
  end
end

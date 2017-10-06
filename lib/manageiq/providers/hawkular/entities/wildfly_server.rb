require_relative 'middleware_server'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        # A specialized version of MiddlewareServer for servers running WildFly.
        class WildflyServer < MiddlewareServer
          attribute :metrics, String
          attribute :bind_address, String
          attribute :product, String
          attribute :version, String

          # Returns if this entity is appliable for given metadata.
          def self.applicable?(data)
            data[:type_path].to_s.include?('WildFly Server')
          end

          def bind_address
            properties[:bound_address]
          end

          def product
            properties[:product_name]
          end

          def server_state
            properties[:server_state]
          end

          def version
            properties[:version]
          end
        end
      end
    end
  end
end

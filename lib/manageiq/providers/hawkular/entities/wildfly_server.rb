require_relative 'middleware_server'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        # A specialized version of MiddlewareServer for servers running WildFly.
        class WildflyServer < MiddlewareServer
          #attribute(:metrics, Array[Hash])
          attribute(:bind_address, String)
          attribute(:product, String)
          attribute(:version, String)

          # Returns if this entity is appliable for given metadata.
          def self.applicable?(data)
            data[:type][:id] == 'WildFly Server'
          end

          def bind_address
            config[:bound_address]
          end

          def product
            config[:product_name]
          end

          def server_state
            config[:server_state]
          end

          def version
            config[:version]
          end
        end
      end
    end
  end
end

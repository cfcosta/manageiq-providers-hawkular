require_relative 'middleware_server'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        # A specialized version of MiddlewareServer for servers running WildFly.
        class WildflyServer < MiddlewareServer
          # Returns if this entity is appliable for given metadata.
          def self.applicable?(data)
            data[:type_path].to_s.end_with?(';WildFly Server')
          end

          def resource_class
            'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly'
          end

          def in_container?
            properties[:in_container] == 'true'
          end

          def container_url
            return nil unless immutable? && properties[:container_id]
            "docker://#{properties[:container_id]}"
          end
        end
      end
    end
  end
end

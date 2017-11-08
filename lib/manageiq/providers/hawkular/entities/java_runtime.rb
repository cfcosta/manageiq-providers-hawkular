require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class JavaRuntime < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type][:id] == 'Runtime MBean'
          end
        end
      end
    end
  end
end

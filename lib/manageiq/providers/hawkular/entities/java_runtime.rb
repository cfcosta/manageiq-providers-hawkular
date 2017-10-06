require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class JavaRuntime < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Runtime MBean')
          end
        end
      end
    end
  end
end

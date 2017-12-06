require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class JmsTopic < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('JMS Topic')
          end
        end
      end
    end
  end
end

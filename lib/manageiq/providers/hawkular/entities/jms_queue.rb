require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class JmsQueue < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('JMS Queue')
          end
        end
      end
    end
  end
end

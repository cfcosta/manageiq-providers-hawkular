require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class HawkularAgent < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Hawkular WildFly Agent')
          end
        end
      end
    end
  end
end

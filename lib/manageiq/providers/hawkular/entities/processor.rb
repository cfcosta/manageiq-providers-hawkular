require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Processor < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Platform_Processor')
          end
        end
      end
    end
  end
end

require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Memory < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Platform_Memory')
          end
        end
      end
    end
  end
end

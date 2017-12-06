require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MemoryPool < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Memory Pool MBean')
          end
        end
      end
    end
  end
end

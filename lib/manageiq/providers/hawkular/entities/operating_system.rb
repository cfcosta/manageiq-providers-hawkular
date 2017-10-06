require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class OperatingSystem < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Platform_Operating System')
          end
        end
      end
    end
  end
end

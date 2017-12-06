require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Infinispan < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].ends_with?('Infinispan')
          end
        end
      end
    end
  end
end

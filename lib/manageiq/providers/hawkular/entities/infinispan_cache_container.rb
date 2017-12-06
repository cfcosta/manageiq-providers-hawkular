require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class InfinispanCacheContainer < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Infinispan Cache Container')
          end
        end
      end
    end
  end
end

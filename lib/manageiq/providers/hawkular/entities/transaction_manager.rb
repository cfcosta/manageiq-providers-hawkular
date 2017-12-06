require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class TransactionManager < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Transaction Manager')
          end
        end
      end
    end
  end
end

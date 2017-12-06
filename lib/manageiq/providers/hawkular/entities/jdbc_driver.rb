require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class JdbcDriver < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('JDBC Driver')
          end
        end
      end
    end
  end
end

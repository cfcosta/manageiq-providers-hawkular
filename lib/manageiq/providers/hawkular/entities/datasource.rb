require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Datasource < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Datasource')
          end
        end
      end
    end
  end
end

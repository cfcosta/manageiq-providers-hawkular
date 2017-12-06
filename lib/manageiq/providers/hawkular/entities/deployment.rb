require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Deployment < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Deployment')
          end
        end
      end
    end
  end
end

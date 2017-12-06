require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Servlet < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Servlet')
          end
        end
      end
    end
  end
end

require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MiddlewareServer < MiddlewareResource
          def self.applicable?(_)
            false
          end
        end
      end
    end
  end
end

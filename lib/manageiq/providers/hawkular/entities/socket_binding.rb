require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class SocketBinding < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Socket Binding')
          end
        end
      end
    end
  end
end

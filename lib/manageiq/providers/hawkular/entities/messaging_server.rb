require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MessagingServer < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Messaging Server')
          end
        end
      end
    end
  end
end

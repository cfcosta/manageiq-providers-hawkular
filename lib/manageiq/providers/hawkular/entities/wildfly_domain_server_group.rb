require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class WildflyDomainServerGroup < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Domain Server Group')
          end

          def name
            super.sub(/^Domain Server Group \[/, '').chomp(']')
          end

          def profile
            properties[:profile]
          end
        end
      end
    end
  end
end

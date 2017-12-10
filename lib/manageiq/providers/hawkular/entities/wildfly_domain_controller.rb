require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class WildflyDomainController < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Host Controller') &&
              metadata[:properties][:process_type] == 'Domain Controller'
          end

          def name
            super.sub(/^[^\.]+\./, '')
          end
        end
      end
    end
  end
end

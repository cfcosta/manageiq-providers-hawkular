require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class Deployment < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Deployment')
          end

          def name
            super
              .sub(/^.*deployment=/, '')
              .match(/\[(.*)\]/) { |x| x[1] } || super
          end
        end
      end
    end
  end
end

require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class DomainWildflyHost < MiddlewareResource
          def self.applicable?(data)
            data[:type_path].to_s.end_with?('Domain Host')
          end

          def name
            URI.unescape(feed).sub(/^[^\.]+\./, '')
          end
        end
      end
    end
  end
end

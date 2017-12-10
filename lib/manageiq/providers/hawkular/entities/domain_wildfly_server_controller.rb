require_relative 'domain_wildfly_server'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class DomainWildflyServerController < MiddlewareResource
          def self.applicable?(data)
            data[:type_path].to_s.include?('Domain WildFly Server Controller')
          end
        end
      end
    end
  end
end

require_relative 'wildfly_server'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class DomainWildflyServer < WildflyServer
          def self.applicable?(data)
            data[:type_path].to_s.end_with?('Domain WildFly Server')
          end

          def name
            super.sub(%r{^.*\/server=}, '')
          end
        end
      end
    end
  end
end

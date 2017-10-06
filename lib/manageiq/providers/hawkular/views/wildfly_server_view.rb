require_relative 'middleware_resource_view'
require_relative '../entities/wildfly_server'

module ManageIQ
  module Providers
    module Hawkular
      module Views
        class WildflyServerView < MiddlewareResourceView
          root = File.expand_path('../schemas', __dir__)
          file = File.join(root, 'wildfly_server_view.json')
          json File.read(file)

          applies_to ::ManageIQ::Providers::Hawkular::Entities::WildflyServer
        end
      end
    end
  end
end

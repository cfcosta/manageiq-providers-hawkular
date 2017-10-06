require_relative '../entities/middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Views
        class MiddlewareResourceView < GenericViewMapper::View
          root = File.expand_path('../schemas', __dir__)
          file = File.join(root, 'middleware_resource_view.json')

          json File.read(file)

          applies_to ::ManageIQ::Providers::Hawkular::Entities::MiddlewareResource
        end
      end
    end
  end
end

require_relative 'middleware_resource'
require_relative '../roles/has_relationships'
require_relative '../roles/has_machine_id'
require 'active_support/core_ext/string'
require 'forwardable'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MiddlewareServer < MiddlewareResource
          include Roles::HasRelationships
          include Roles::HasMachineId

          def self.applicable?(_)
            false
          end

          def name
            super
              .sub(/~~$/, '')
              .sub(/^.*?~/, '')
              .match(/\[(.*)\]/) { |x| x[1] } || super
          end

          def hostname
            properties[:hostname] || _('not yet available')
          end

          def product
            properties[:product_name] || _('not yet available')
          end

          # This is meant to be subclassed when a server has a different type
          # on the db.
          def resource_class
            'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer'
          end

          def in_container?
            raise NotImplementedError, 'this property is not implemented for this class'
          end

          def container_url
            raise NotImplementedError, 'this property is not implemented for this class'
          end
        end
      end
    end
  end
end

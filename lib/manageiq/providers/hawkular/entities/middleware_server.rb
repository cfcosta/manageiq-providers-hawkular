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
            super.match(/\[(.*)\]/) { |x| x[1] }
          end

          def prepared_name
            name.sub(/~~$/, '').sub(/^.*?~/, '')
          end

          def hostname
            properties[:hostname] || _('not yet available')
          end

          def product
            properties[:product_name] || _('not yet available')
          end

          def immutable?
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

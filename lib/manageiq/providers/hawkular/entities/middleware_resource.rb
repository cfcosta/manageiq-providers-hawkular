require 'generic_view_mapper'
require 'active_support/core_ext/string'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MiddlewareResource < GenericViewMapper::Entity
          attribute(:id, Integer)
          attribute(:name, String)
          attribute(:feed, String)
          attribute(:properties, Hash[Symbol, String])
          attribute(:config, Hash[Symbol, String])
          attribute(:type_path, String)
          attribute(:path, String)

          attr_reader :original_attributes

          def initialize(attributes)
            @original_attributes = attributes
            super
          end

          def self.applicable?(_)
            true
          end

          # Returns a key to group all entities of a given type:
          #
          # Examples:
          # MiddlewareServer => :middleware_servers
          # JdbcDriver => :jdbc_drivers
          #
          # This is used by RelationshipProxy to provide proper data filtering
          # on the relationships.
          def self.class_key
            name.split('::').last.underscore.pluralize.to_sym
          end

          def class_key
            self.class.class_key
          end
        end
      end
    end
  end
end

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MiddlewareResource < GenericViewMapper::Entity
          attribute(:id, Integer)
          attribute(:name, String)
          attribute(:feed, String)
          attribute(:properties, Hash[Symbol, String])
          attribute(:type_path, String)
          attribute(:path, String)

          def self.applicable?(_)
            true
          end
        end
      end
    end
  end
end

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class MiddlewareResource < GenericViewMapper::Entity
          attribute(:id, Integer)
          attribute(:name, String)
          attribute(:feed_id, String)
          attribute(:properties, Hash[Symbol, String])
          attribute(:config, Hash[Symbol, String])
          attribute(:type, Hash[Symbol, String])

          def self.applicable?(_)
            true
          end
        end
      end
    end
  end
end

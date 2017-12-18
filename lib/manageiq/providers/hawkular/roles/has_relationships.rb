module ManageIQ
  module Providers
    module Hawkular
      module Roles
        module HasRelationships
          class RelationshipProxy
            include Enumerable

            attr_reader :all, :grouped

            def initialize(relationships)
              @all = relationships
              @grouped = relationships.group_by(&:class_key)

              possible_keys = Entities::MiddlewareResource.descendants
                                                          .map(&:class_key)

              self.class.instance_exec do
                possible_keys.each do |key|
                  define_method(key) { grouped.fetch(key) { [] } }
                end
              end
            end

            def each(*args, &block)
              @all.each(*args, &block)
            end
          end

          def relationships
            @relationships ||= RelationshipProxy.new([])
          end

          def relationships=(target)
            @relationships = RelationshipProxy.new(target)
          end
        end
      end
    end
  end
end

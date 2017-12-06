require_relative 'middleware_resource'
require 'active_support/core_ext/string'
require 'forwardable'

module ManageIQ
  module Providers
    module Hawkular
      module Entities

        class RelationshipProxy
          include Enumerable

          attr_reader :all

          def initialize(relationships)
            @all = relationships

            prepared = relationships.group_by(&:class_key)
            self.class.instance_exec do
              prepared.each_pair do |key, values|
                define_method(key) { values.uniq }
              end
            end
          end

          def each(*args, &block)
            @all.each(*args, &block)
          end

          def size
            @all.size
          end
        end

        class MiddlewareServer < MiddlewareResource
          attr_reader :relationships

          def self.applicable?(_)
            false
          end

          def relationships=(target)
            @relationships = RelationshipProxy.new(target)
          end
        end
      end
    end
  end
end

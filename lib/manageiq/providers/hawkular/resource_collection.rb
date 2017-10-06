require_relative 'entity_mapper'
require_relative 'entities/middleware_server'
require_relative 'entities/wildfly_server'

module ManageIQ
  module Providers
    module Hawkular
      class ResourceCollection
        attr_reader :data

        def initialize(resources)
          @data = resources.map { |r| r.instance_variable_get(:@_hash) }
        end

        def entities
          @entities ||= data.map do |d|
            data = EntityMapper.map(d)
            GenericViewMapper.matcher.find_entity_for(data).new(data)
          end
        end

        def prepared
          servers = entities.select { |x| x.is_a? Entities::MiddlewareServer }
          resources = (entities - servers).group_by(&:feed)


          servers.each do |server|
            server.properties.reverse_merge!(resources.inject({}) { |accum,el| accum.merge(el.properties)})
          end

          entities
        end
      end
    end
  end
end

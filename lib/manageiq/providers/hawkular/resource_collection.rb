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
          @entities ||= data.flat_map do |d|
            data = clean_up_keys(d)
            GenericViewMapper.matcher.find_entity_for(data).new(data)
          end
        end

        def prepared
          servers = entities.select { |x| x.kind_of?(Entities::MiddlewareServer) }
          resources = (entities - servers).group_by(&:feed_id)

          servers.each do |server|
            server.config.reverse_merge!(
              resources[server.feed_id].inject({}) { |accum, el| accum.merge(el.config) }
            )
          end

          entities
        end

        private def clean_up_keys(hash)
          hash.map do |(k,v)|
            key = k.underscore.gsub(/\s/, '_')

            case v
            when Hash
              [key, clean_up_keys(v)]
            else
              [key, v]
            end
          end.to_h.symbolize_keys
        end
      end
    end
  end
end

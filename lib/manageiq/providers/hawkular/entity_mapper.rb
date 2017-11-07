require 'cgi'

module ManageIQ
  module Providers
    module Hawkular
      class EntityMapper
        def self.map(data)
          new(data).map
        end

        attr_reader :data

        def initialize(data)
          @data = data.dup.symbolize_keys
        end

        def map
          properties = clean_up_keys(data.delete(:properties))
          config = clean_up_keys(data.delete(:config))
          type = clean_up_keys(data.delete(:type))

          {
            :id => data.delete(:id),
            :feed => data.delete(:feedId),
            :name => data.delete(:name),
            :properties => properties,
            :config => config,
            :type => type
          }.reverse_merge(data)
        end

        private def clean_up_keys(hash)
          hash
            .map { |(k,v)| [k.underscore.gsub(/\s/, '_'), v] }
            .to_h
            .symbolize_keys
        end
      end
    end
  end
end

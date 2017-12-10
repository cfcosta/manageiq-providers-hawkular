require 'cgi'

module ManageIQ
  module Providers
    module Hawkular
      class EntityMapper
        def self.map(data)
          new(data).map
        end

        def initialize(data)
          @data = data.dup.symbolize_keys
        end

        def map
          feed = @data[:resourceTypePath].match(/;([0-9a-zA-Z.\s%]+)\/rt/)[1]

          {
            :id         => @data.delete(:id),
            :feed       => feed,
            :name       => @data.delete(:name),
            :path       => @data.delete(:path),
            :properties => prepare(@data.delete(:properties)),
            :config     => prepare(@data.delete(:config)),
            :type_path  => CGI.unescape(@data.delete(:resourceTypePath))
          }.merge(@data)
        end

        private

        def prepare(hash)
          hash.map { |(k, v)| [k.underscore.gsub(/\s/, '_'), v] }.to_h.symbolize_keys
        end
      end
    end
  end
end

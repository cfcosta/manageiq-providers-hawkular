require_relative 'middleware_resource'

module ManageIQ
  module Providers
    module Hawkular
      module Entities
        class FileStore < MiddlewareResource
          def self.applicable?(metadata)
            metadata[:type_path].include?('Platform_File Store')
          end
        end
      end
    end
  end
end

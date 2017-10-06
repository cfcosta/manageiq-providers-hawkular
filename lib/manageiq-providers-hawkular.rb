require 'manageiq/providers/hawkular/engine'
require 'manageiq/providers/hawkular/version'

require 'generic_view_mapper'

require 'manageiq/providers/hawkular/connection'
require 'manageiq/providers/hawkular/resource_collection'

root = File.expand_path('./manageiq/providers/hawkular', __dir__)
Dir.glob(File.join(root, '{entities,views}', '*.rb')) do |file|
  require file
end

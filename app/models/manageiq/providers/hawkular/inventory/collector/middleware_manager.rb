require 'hawkular/hawkular_client'

module ManageIQ::Providers
  class Hawkular::Inventory::Collector::MiddlewareManager < ManagerRefresh::Inventory::Collector
    include ::Hawkular::ClientUtils

    def connection
      @connection ||= manager.connect
    end

    def mapper
      @mapper ||= ManageIQ::Providers::Hawkular::Connection.new(connection)
    end

    def all_resources
      @all_resources ||= mapper.fetch_all_resources
    end

    def config_data_for_resource(resource_path)
      connection.inventory.get_config_data_for_resource(resource_path)
    end

    def metrics_for_metric_type(feed, metric_type_id)
      metric_type_path = ::Hawkular::Inventory::CanonicalPath.new(
        :metric_type_id => metric_type_id, :feed_id => feed
      )
      connection.inventory.list_metrics_for_metric_type(metric_type_path)
    end

    def raw_availability_data(*args)
      connection.metrics.avail.raw_data(*args)
    end
  end
end

require_relative '../../../middleware_manager/hawkular_helper'

RSpec.describe 'Inventory Refresh: Standalone Server' do
  include InventoryRefreshHelpers

  let(:collection) { [InventoryRefreshHelpers::Factories.standalone_server] }

  setup_refresh!

  describe 'server entity' do
    let(:server) { db_class(:MiddlewareServer).first }

    it 'is persisted with correct data' do
      EmsRefresh.refresh(ems)

      expect(db_class(:MiddlewareServer).count).to eq 1

      expect(server.attributes).to include(
        'name' => 'Local',
        'feed' => '27cc3b363349',
        'ems_ref' => '/t;hawkular/f;27cc3b363349/r;Local~~',
        'nativeid' => 'Local~~',
        'type_path' => '/t;hawkular/f;27cc3b363349/rt;WildFly%20Server',
        'hostname' => '27cc3b363349',
        'product' => 'Hawkular',
        'type' => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly',
        'ems_id' => ems.id
      )
    end
  end

  describe 'deployments' do
    let(:deployment) { db_class(:MiddlewareDeployment).first }

    it 'is persisted with correct data' do
      EmsRefresh.refresh(ems)

      expect(db_class(:MiddlewareDeployment).count).to eq 1

      expect(deployment.attributes).to include(
        "name" => "hawkular-alerts-action-elasticsearch.war",
        "ems_ref" => "/t;hawkular/f;27cc3b363349/r;Local~~/r;Local~%2Fdeployment%3Dhawkular-metrics.ear/r;Local~%2Fdeployment%3Dhawkular-metrics.ear%2Fsubdeployment%3Dhawkular-alerts-action-elasticsearch.war",
        "nativeid" => "Local~/deployment=hawkular-metrics.ear/subdeployment=hawkular-alerts-action-elasticsearch.war",
        "server_id" => db_class(:MiddlewareServer).first.id,
        "ems_id" => ems.id,
        "feed" => "27cc3b363349",
        "properties" => "{}",
        "server_group_id" => nil,
        "type" => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareDeployment"
      )
    end
  end

  describe 'datasources' do
    let(:datasource) { db_class(:MiddlewareDatasource).first }

    it 'is persisted with correct data' do
      EmsRefresh.refresh(ems)

      expect(db_class(:MiddlewareDatasource).count).to eq 1

      expect(datasource.attributes).to include(
        "name" => "Datasource [ExampleDS]",
        "ems_ref" => "/t;hawkular/f;27cc3b363349/r;Local~~/r;Local~%2Fsubsystem%3Ddatasources%2Fdata-source%3DExampleDS",
        "nativeid" => "Local~/subsystem=datasources/data-source=ExampleDS",
        "server_id" => db_class(:MiddlewareServer).first.id,
        "ems_id" => ems.id,
        "feed" => "27cc3b363349",
        "type" => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareDatasource"
      )
    end
  end
end

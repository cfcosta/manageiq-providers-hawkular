def db_class(klass)
  "ManageIQ::Providers::Hawkular::MiddlewareManager::#{klass}".constantize
end

# Feed id to be used for all spec
def the_feed_id
  'wf-standalone'.freeze
end

def the_domain_feed_id
  'wf-domain'.freeze
end

def test_mw_manager_feed_id
  'mw-manager'.freeze
end

def test_machine_id
  # change me if needed during re-recording the vcrs
  'ee0137a08d38'.freeze
end

def test_start_time
  Time.new(2016, 10, 19, 8, 0, 0, "+00:00").freeze
end

def test_end_time
  Time.new(2016, 10, 19, 10, 0, 0, "+00:00").freeze
end

def test_hostname
  # 'hservices.torii.gva.redhat.com'.freeze
  'localhost'.freeze
end

def test_port
  # 80
  8080
end

def test_userid
  'jdoe'.freeze
end

def test_password
  'password'.freeze
end

def ems_hawkular_fixture
  _guid, _server, zone = EvmSpecHelper.create_guid_miq_server_zone
  auth = AuthToken.new(:name => "test", :auth_key => "valid-token", :userid => "jdoe", :password => "password")
  FactoryGirl.create(:ems_hawkular,
                     :hostname        => test_hostname,
                     :port            => test_port,
                     :authentications => [auth],
                     :zone            => zone)
end

module InventoryRefreshHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def setup_refresh!
      let(:ems) { ems_hawkular_fixture }
      let(:collector) { instance_double(collector_class.to_s) }

      before do
        allow_any_instance_of(parser_class).to receive(:fetch_availabilities)
        allow_any_instance_of(collector_class).to receive(:all_resources) { collection }
      end
    end
  end

  module Factories
    include ManageIQ::Providers::Hawkular::Entities

    extend self

    def standalone_server
      server = WildflyServer.new(
        :id => "Local~~",
        :name => "Local",
        :feed => "27cc3b363349",
        :properties => {
          :suspend_state => "RUNNING",
          :bound_address => "127.0.0.1",
          :running_mode => "NORMAL",
          :home_directory => "/opt/jboss/wildfly",
          :version => "0.38.0.Final",
          :node_name => "27cc3b363349",
          :server_state => "running",
          :product_name => "Hawkular",
          :hostname => "27cc3b363349",
          :uuid => "5f46e04c-cd5e-40de-b73c-fd25109aaee5",
          :name => "27cc3b363349"
        },
        :config => {
          :value => {
            "Suspend State" => "RUNNING",
            "Bound Address" => "127.0.0.1",
            "Running Mode" => "NORMAL",
            "Home Directory" => "/opt/jboss/wildfly",
            "Version" => "0.38.0.Final",
            "Node Name" => "27cc3b363349",
            "Server State" => "running",
            "Product Name" => "Hawkular",
            "Hostname" => "27cc3b363349",
            "UUID" => "5f46e04c-cd5e-40de-b73c-fd25109aaee5",
            "Name" => "27cc3b363349"}
        },
        :type_path => "/t;hawkular/f;27cc3b363349/rt;WildFly Server",
        :path => "/t;hawkular/f;27cc3b363349/r;Local~~",
        :relationships => [
          deployment,
          datasource
        ]
      )
    end

    def deployment
      Deployment.new(
        :id => "Local~/deployment=hawkular-metrics.ear/subdeployment=hawkular-alerts-action-elasticsearch.war",
        :name => "hawkular-alerts-action-elasticsearch.war",
        :feed => "27cc3b363349",
        :properties => {},
        :config => { :value => nil },
        :type_path => "/t;hawkular/f;27cc3b363349/rt;SubDeployment",
        :path => "/t;hawkular/f;27cc3b363349/r;Local~~/r;Local~%2Fdeployment%3Dhawkular-metrics.ear/r;Local~%2Fdeployment%3Dhawkular-metrics.ear%2Fsubdeployment%3Dhawkular-alerts-action-elasticsearch.war"
      )
    end

    def datasource
      Datasource.new(
        :id => "Local~/subsystem=datasources/data-source=ExampleDS",
        :feed => "27cc3b363349",
        :name => "Datasource [ExampleDS]",
        :path => "/t;hawkular/f;27cc3b363349/r;Local~~/r;Local~%2Fsubsystem%3Ddatasources%2Fdata-source%3DExampleDS",
        :properties => {
          :connection_properties => nil,
          :datasource_class => nil,
          :security_domain => nil,
          :username => "sa",
          :driver_name => "h2",
          :jndi_name => "java:jboss/datasources/ExampleDS",
          :connection_url => "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE",
          :enabled => "true",
          :driver_class => nil,
          :password => "sa"
        },
        :config => {
          :value => {
            "Connection Properties" => nil,
            "Datasource Class" => nil,
            "Security Domain" => nil,
            "Username" => "sa",
            "Driver Name" => "h2",
            "JNDI Name" => "java:jboss/datasources/ExampleDS",
            "Connection URL" => "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE",
            "Enabled" => "true",
            "Driver Class" => nil,
            "Password" => "sa"
          }
        },
        :type_path => "/t;hawkular/f;27cc3b363349/rt;Datasource",
        :outgoing => {},
        :incoming => {}
      )
    end
  end

  def collector_class
    ManageIQ::Providers::Hawkular::Inventory::Collector::MiddlewareManager
  end

  def parser_class
    ManageIQ::Providers::Hawkular::Inventory::Parser::MiddlewareManager
  end
end

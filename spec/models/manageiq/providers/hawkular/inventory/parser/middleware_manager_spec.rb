require_relative '../../middleware_manager/hawkular_helper'

RSpec.describe 'Inventory Refresh: Empty' do
  include InventoryRefreshHelpers

  setup_refresh!

  describe 'for empty collection' do
    let(:collection) { [] }

    it 'does nothing' do
      EmsRefresh.refresh(ems)

      expect(db_class(:MiddlewareServer).count).to be_zero
      expect(db_class(:MiddlewareDatasource).count).to be_zero
      expect(db_class(:MiddlewareDeployment).count).to be_zero
      expect(db_class(:MiddlewareDomain).count).to be_zero
      expect(db_class(:MiddlewareMessaging).count).to be_zero
      expect(db_class(:MiddlewareServerGroup).count).to be_zero
    end
  end
end

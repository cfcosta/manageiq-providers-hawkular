RSpec.describe ManageIQ::Providers::Hawkular::Entities::MiddlewareResource do
  describe '.applicable?' do
    it 'is always true' do
      expect(described_class).to be_applicable(nil)
      expect(described_class).to be_applicable({})
    end
  end

  describe '#original_attributes' do
    it 'returns the attributes used to define the key' do
    end
  end
end

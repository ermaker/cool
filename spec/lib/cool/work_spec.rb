require 'cool/work'
RSpec.describe Cool::Work do
  describe '#execute' do
    it 'works' do
      work = described_class.new 'true'
      expect(work.execute).to eq(true)
      work = described_class.new 'false'
      expect(work.execute).to eq(false)
    end

    it 'works with method definition' do
      work = described_class.new <<-EOC
def value
@value
end
@value = 1
value
      EOC
      expect(work.execute).to eq(1)
      expect(work.value).to eq(1)
    end

    it 'works with extend module' do
      work = described_class.new <<-EOC
extend Module.new { attr_reader :value }
@value = 1
self.value
      EOC
      expect(work.execute).to eq(1)
      expect(work.value).to eq(1)
    end

    it 'works with instance_eval' do
      work = described_class.new <<-EOC
self.class.instance_eval { attr_reader :value }
@value = 1
self.value
      EOC
      expect(work.execute).to eq(1)
      expect(work.value).to eq(1)
    end
  end
end

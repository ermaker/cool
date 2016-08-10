RSpec.describe Symbol do
  subject { :+ }
  it { is_expected.to be_a(described_class) }
  specify do
    expect((0..10).map(&subject.args(1))).to eq((1..11).to_a)
  end
end

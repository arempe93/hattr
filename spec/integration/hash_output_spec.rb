describe Hattr::HashBuilder, '#generate' do
  subject { described_class }

  it 'simple example' do
    spec   = { _hattr_options: Hattr::ClassMethods::GROUP_DEFAULTS, int: { type: Integer }, arr: { type: Array }, hsh: { type: Hash[Symbol => Float] } }
    raw    = { 'int' => '123', arr: ['one', 'two', 'three'].to_s, hsh: { 'one' => '1.0', 'two' => '2.0', 'three' => '3.0' }.to_s }
    output = { int: 123, arr: ['one', 'two', 'three'], hsh: { one: 1.0, two: 2.0, three: 3.0 } }

    expect(subject.generate(spec, raw)).to eql output
  end
end

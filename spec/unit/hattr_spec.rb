describe Hattr do
  context '::extended' do
    let(:receiver) { Class.new }
    before { receiver.extend Hattr }

    it 'should extend ClassMethods' do
      expect(receiver).to respond_to :hattr
      expect(receiver).to respond_to :hattr_group
    end

    it 'should create `hattr_groups` class variable' do
      expect(receiver.hattr_groups).to be_a Hash
    end
  end
end

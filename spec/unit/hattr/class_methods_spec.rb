describe Hattr::ClassMethods do
  subject { Class.new.extend(Hattr) }

  context '::hattr_group' do
    let(:field) { :group }
    let(:options) { Hash.new }
    after { subject.hattr_group(field, options) }

    it 'should validate group level options' do
      expect(subject).to receive(:validate_options).with(options, described_class::GROUP_OPTIONS)
    end

    it 'should store group' do
      expect(subject).to receive(:store_group).with(field, described_class::GROUP_DEFAULTS.merge(options))
    end
  end

  context '::hattr' do
    let(:field) { :group }
    let(:attribute) { :attr }
    let(:options) { Hash.new }

    context 'when using reserved attribute name' do
      let(:attribute) { described_class::OPTIONS_STORAGE_KEY }

      it 'should raise ArgumentError' do
        expect { subject.hattr(field, attribute, options) }.to raise_error ArgumentError
      end
    end

    context 'when valid input provided' do
      after { subject.hattr(field, attribute, options) }

      it 'should validate attribute level options' do
        expect(subject).to receive(:validate_options).with(options, described_class::ATTR_OPTIONS)
      end

      it 'should store attribute' do
        expect(subject).to receive(:store_attribute).with(field, attribute, described_class::ATTR_DEFAULTS.merge(options))
      end
    end
  end

  context '::validate_options' do
    let(:options) { described_class::GROUP_DEFAULTS }

    context 'when invalid keys given' do
      let(:options) { Hash[foo: :bar] }

      it 'should raise ArgumentError' do
        expect { subject.send(:validate_options, options, described_class::GROUP_OPTIONS) }.to raise_error ArgumentError
      end
    end

    context 'when all keys are valid' do
      it 'should not raise error' do
        expect { subject.send(:validate_options, options, described_class::GROUP_OPTIONS) }.to_not raise_error
      end
    end
  end

  context '::store_group' do
    let(:field) { :group }
    let(:options) { Hash[foo: :bar] }
    before { subject.send(:store_group, field, options) }
    after  { subject.send(:store_group, field, options) }

    it 'should store options in `hattr_groups`' do
      expect(subject.hattr_groups[field]).to eql Hash[described_class::OPTIONS_STORAGE_KEY => options]
    end

    it 'should create reader method for field' do
      expect(subject).to receive(:create_reader_method).with(field)
    end
  end

  context '::store_attribute' do
    let(:field) { :group }
    let(:attribute) { :attr }
    let(:options) { Hash[foo: :bar] }

    context 'when group not yet defined' do
      after { subject.send(:store_attribute, field, attribute, options) }

      it 'should store group with default options' do
        expect(subject).to receive(:store_group).with(field, described_class::GROUP_DEFAULTS)
      end
    end

    context 'when group already defined' do
      before { subject.hattr_groups[field] = { described_class::OPTIONS_STORAGE_KEY => described_class::GROUP_DEFAULTS } }
      after  { subject.send(:store_attribute, field, attribute, options) }

      it 'should not store group again' do
        expect(subject).to_not receive(:store_group)
      end
    end

    it 'should store options in group' do
      subject.send(:store_attribute, field, attribute, options)
      expect(subject.hattr_groups[field][attribute]).to eql options
    end
  end

  context '::create_reader_method' do
    let(:field) { :group }
    before { subject.send(:create_reader_method, field) }

    it 'should add instance method with name field' do
      expect(subject.new).to respond_to field
    end
  end

  context '::build_group_hash' do
    let(:spec) { Hash[foo: :bar] }
    let(:value) { Hash.new[boo: :baz]}
    after { subject.send(:build_group_hash, spec, value) }

    it 'should generate hash' do
      expect(Hattr::HashBuilder).to receive(:generate).with(spec, value)
    end
  end
end

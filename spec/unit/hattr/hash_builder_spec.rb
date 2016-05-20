describe Hattr::HashBuilder do
  subject { described_class }

  TYPECAST_TEST_SET = {
    Integer => { pre: '123', post: 123 },
    Fixnum  => { pre: '123', post: 123 },
    String  => { pre: 'foo', post: 'foo' },
    Float   => { pre: '1.2', post: 1.2 },
    Symbol  => { pre: 'foo', post: :foo }
  }

  context '::typecast' do
    let(:value) { nil }
    after { subject.typecast(value, type) }

    context 'when type is Hash' do
      let(:type) { Hash[foo: :bar] }
      it 'should cast with hash_typecast' do
        expect(subject).to receive(:hash_typecast).with(value, type)
      end
    end

    context 'when type is Array' do
      let(:type) { Array[:foo] }
      it 'should cast with array_typecast' do
        expect(subject).to receive(:array_typecast).with(value, type)
      end
    end

    context 'when type is Class' do
      let(:type) { Class }
      it 'should cast with primitive_typecast' do
        expect(subject).to receive(:primitive_typecast).with(value, type)
      end
    end
  end

  context '::primitive_typecast' do
    context 'when class is primitive type' do
      before { @result = subject.primitive_typecast(value, type) }

      TYPECAST_TEST_SET.each do |key, value|
        context "when type is #{key}" do
          let(:value) { value[:pre] }
          let(:type) { key }

          it 'should cast correctly' do
            expect(@result).to eql value[:post]
          end
        end
      end
    end

    context 'when class is data structure' do
      let(:value) { nil }
      after { subject.primitive_typecast(value, type) }

      context 'when type is Array' do
        let(:type) { Array }
        it 'should call array_typecast' do
          expect(subject).to receive(:array_typecast).with(value, described_class::ARRAY_TYPE_DEFAULT)
        end
      end

      context 'when type is Hash' do
        let(:type) { Hash }
        it 'should call hash_typecast' do
          expect(subject).to receive(:hash_typecast).with(value, described_class::HASH_TYPE_DEFAULT)
        end
      end
    end
  end

  context '::hash_typecast' do
    let(:key_type) { String }
    let(:val_type) { Integer }
    let(:value) { Hash['one' => '1'] }
    let(:model) { Hash[key_type => val_type] }
    after { subject.hash_typecast(value.to_s, model) }

    it 'should convert string to hash' do
      expect(subject).to receive(:string_to_hash).with(value.to_s).and_return(value)
    end

    it 'should convert each value to given type' do
      value.values.each do |val|
        expect(subject).to receive(:typecast).with(val, val_type)
      end
    end

    context 'when key type is Symbol' do
      let(:key_type) { Symbol }
      it 'should symbolize keys' do
        expect(subject).to receive(:string_to_hash).with(value.to_s).and_return(value)
        expect(value).to receive(:symbolize_keys).and_return(value.symbolize_keys)
      end
    end
  end

  context '::array_typecast' do
    let(:val_type) { Integer }
    let(:value) { Array['1'] }
    let(:model) { Array[val_type] }
    after { subject.array_typecast(value.to_s, model) }

    it 'should convert string to array' do
      expect(subject).to receive(:string_to_array).with(value.to_s).and_return(value)
    end

    it 'should convert each value to given type' do
      value.each do |val|
        expect(subject).to receive(:typecast).with(val, val_type)
      end
    end
  end

  context '::string_to_hash' do
    let(:value) { Hash['foo' => 'bar'] }
    it 'should reverse hash.to_s' do
      expect(subject.string_to_hash(value.to_s)).to eql value
    end
  end

  context '::string_to_array' do
    let(:value) { Array['foo', 'bar'] }
    it 'should reverse array.to_s' do
      expect(subject.string_to_array(value.to_s)).to eql value
    end
  end
end

shared_examples 'application service#create' do |model_class|
  context 'with invalid data' do
    subject { described_class.new invalid_parameters }

    it 'does not create a new record' do
      expect { subject.create }.not_to change(model_class, :count)
    end

    describe 'errors' do
      before { subject.create }

      it { expect(subject).not_to be_success }
      it { expect(subject.errors).not_to be_empty }
    end
  end

  context 'with valid data' do
    subject { described_class.new valid_parameters }

    it 'creates a new record' do
      expect { subject.create }.to change(model_class, :count).by(1)
    end

    describe 'success' do
      before { subject.create }

      it 'creates with the correct data' do
        record = subject.record

        verify_saved_record_data(record)
      end

      it { expect(subject).to be_success }
      it { expect(subject.record).to eq(model_class.last) }
      it { expect(subject.errors).to be_empty }
    end
  end
end

shared_examples 'application service#update' do |model_class|
  context 'with invalid data' do
    subject { described_class.new invalid_parameters }

    it 'does not create a new record' do
      expect { subject.update(@record.id) }.not_to change(model_class, :count)
    end

    describe 'fails' do
      before { subject.update(@record.id) }

      it { expect(subject).not_to be_success }
      it { expect(subject.errors).not_to be_empty }
    end
  end

  context 'with valid data' do
    subject { described_class.new valid_parameters }

    it 'does not create a new record' do
      expect { subject.update(@record.id) }.not_to change(model_class, :count)
    end

    describe 'success' do
      before { subject.update(@record.id) }

      it { expect(subject).to be_success }
      it { expect(subject.errors).to be_empty }

      it 'updates the correct data' do
        record = subject.record
        verify_saved_record_data(record)
      end

      it 'returns the updated record' do
        expect(subject.record).to eq(@record.reload)
      end
    end
  end
end

shared_examples 'application service#destroy' do |model_class|
  subject { described_class.new }

  context 'with error' do
    before do
      allow(model_class).to receive(:find).and_return(@record)
      allow(@record).to receive(:discard).and_return(false)
      allow(@record).to receive(:errors).and_return(double(:errors, full_messages: %w[bar]))
    end

    it 'does not discard the record' do
      expect { subject.destroy(@record.id) }.not_to change(model_class.discarded, :count)
    end

    describe 'fails' do
      before { subject.destroy(@record.id) }

      it { expect(subject).not_to be_success }
      it { expect(subject.errors).not_to be_empty }
    end
  end

  context 'with valid data' do
    it 'discards the record' do
      expect { subject.destroy(@record.id) }.to change(model_class.with_discarded.discarded, :count).by(1)
    end

    describe 'success' do
      before { subject.destroy(@record.id) }

      it { expect(subject).to be_success }
      it { expect(subject.record).to eq(@record.reload) }
      it { expect(subject.errors).to be_empty }
    end
  end
end

shared_examples 'application service#restore' do |model_class|
  subject { described_class.new }

  context 'with error' do
    let(:with_discarded) { double(:with_discarded, find: @record) }

    before do
      allow(model_class).to receive(:with_discarded).and_return(with_discarded)
      allow(@record).to receive(:undiscard).and_return(false)
      allow(@record).to receive(:errors).and_return(double(:errors, full_messages: %w[bar]))
    end

    it 'does not undiscard the record' do
      expect { subject.restore(@record.id) }.not_to change(model_class.kept, :count)
    end

    describe 'fails' do
      before { subject.restore(@record.id) }

      it { expect(subject).not_to be_success }
      it { expect(subject.errors).not_to be_empty }
    end
  end

  context 'with valid data' do
    it 'undiscards the record' do
      expect { subject.restore(@record.id) }.to change(model_class.kept, :count).by(1)
    end

    describe 'success' do
      before { subject.restore(@record.id) }

      it { expect(subject).to be_success }
      it { expect(subject.record).to eq(@record.reload) }
      it { expect(subject.errors).to be_empty }
    end
  end
end

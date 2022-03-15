require 'rails_helper'

RSpec.describe PropertyService, type: :service do
  describe 'creation' do
    let(:service) { described_class.new(parameters) }

    context 'with invalid parameters' do
      let(:parameters) { { 'name' => '' } }

      it 'does not create a new property' do
        expect { service.create }.not_to change(Property, :count)
      end

      it 'returns false' do
        service.create

        expect(service.success?).to be(false)
      end

      it 'returns the errors' do
        service.create

        expect(service.errors).not_to be_empty
      end
    end

    context 'with valid parameters' do
      let(:parameters) { { 'name' => 'Lorem' } }

      it 'creates a new property' do
        expect { service.create }.to change(Property, :count).by(1)
      end

      it 'returns the created property' do
        service.create

        expect(service.record).to eq(Property.last)
      end

      it 'returns true' do
        service.create

        expect(service.success?).to be(true)
      end

      it 'populates the data' do
        service.create

        property = service.record

        expect(property.name).to eq('Lorem')
      end
    end
  end

  describe 'update' do
    let(:service) { described_class.new(parameters) }

    before do
      @property = create(:property)
    end

    context 'with invalid parameters' do
      let(:parameters) { { 'name' => '' } }

      it 'does not create a new property' do
        expect do
          service.update(@property.id)
        end.not_to change(Property, :count)
      end

      it 'returns false' do
        service.update(@property.id)

        expect(service.success?).to be(false)
      end

      it 'returns the errors' do
        service.update(@property.id)

        expect(service.errors).not_to be_empty
      end
    end

    context 'with valid parameters' do
      let(:parameters) { { 'name' => 'Foo' } }

      it 'updates the property' do
        service.update(@property.id)

        property = service.record

        expect(property.name).to eq('Foo')
      end
    end
  end

  describe 'destroy' do
    let(:service) { described_class.new }

    before do
      @property = create(:property)
    end

    context 'with invalid parameters' do
      let(:property) { mock_model(Property, destroy: false, errors: double(:errors, full_messages: ['lorem ipsum'])) }

      before do
        allow(Property).to receive(:find).and_return(property)
      end

      it 'does not destroy a property' do
        expect do
          service.destroy(@property.id)
        end.not_to change(Property, :count)
      end

      it 'returns false' do
        service.destroy(@property.id)

        expect(service.success?).to be(false)
      end

      it 'returns the errors' do
        service.destroy(@property.id)

        expect(service.errors).not_to be_empty
      end
    end

    context 'with valid parameters' do
      it 'destroys the property' do
        expect do
          service.destroy(@property.id)
        end.to change(Property, :count).by(-1)
      end

      it 'returns true' do
        service.destroy(@property.id)

        expect(service.success?).to be(true)
      end
    end
  end
end

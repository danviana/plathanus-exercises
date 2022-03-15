require 'rails_helper'

RSpec.describe RomanNumeralService, type: :service do
  describe 'convert_to_roman_numeral' do
    let(:service) { described_class.new }

    context 'with error' do
      it 'returns false' do
        service.convert_to_roman_numeral('lorem ipsum')

        expect(service.success).to be_falsey
      end

      it 'returns the errors' do
        service.convert_to_roman_numeral('lorem ipsum')

        expect(service.errors).not_to be_empty
      end
    end

    context 'with success' do
      it 'returns true' do
        service.convert_to_roman_numeral(14)

        expect(service.success).to be_truthy
      end

      it 'returns roman numeral LXXIX' do
        service.convert_to_roman_numeral(79)

        expect(service.converted_number).to eq('LXXIX')
      end

      it 'returns roman numeral CCXXV' do
        service.convert_to_roman_numeral(225)

        expect(service.converted_number).to eq('CCXXV')
      end

      it 'returns roman numeral DCCCXLV' do
        service.convert_to_roman_numeral(845)

        expect(service.converted_number).to eq('DCCCXLV')
      end

      it 'returns roman numeral MMXXII' do
        service.convert_to_roman_numeral(2022)

        expect(service.converted_number).to eq('MMXXII')
      end
    end
  end
end

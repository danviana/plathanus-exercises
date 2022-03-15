require 'rails_helper'

RSpec.describe RomanNumeralsController, type: :controller do
  describe 'GET index' do
    let(:parameters) { { number: 44 } }

    def do_request
      get :index, xhr: true, params: parameters
    end

    it 'renders the index template' do
      do_request

      expect(response).to render_template(:index)
    end

    context 'with error' do
      let(:parameters) { { number: 'foo bar' } }

      it 'returns ok status' do
        do_request

        expect(response).to have_http_status(:ok)
      end

      it 'returns the errors' do
        do_request

        expect(flash[:error]).to be_present
      end
    end

    context 'with success' do
      let(:parameters) { { number: 44 } }

      it 'returns ok status' do
        do_request

        expect(response).to have_http_status(:ok)
      end

      it 'returns number and converted_number' do
        allow(controller).to receive(:render).with no_args
        expect(controller).to receive(:render).with(:index, {
                                                      locals: { number: '44', converted_number: 'XLIV' }
                                                    })

        do_request
      end
    end
  end
end

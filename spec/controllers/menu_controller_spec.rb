require 'rails_helper'

RSpec.describe MenuController, type: :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'returns ok status' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end

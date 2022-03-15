require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  describe 'GET index' do
    before do
      @property1 = create(:property)
      @property2 = create(:property)
      @property3 = create(:property)
    end

    def do_request
      get :index, xhr: true
    end

    it 'renders the index template' do
      do_request

      expect(response).to render_template(:index)
    end

    it 'returns ok status' do
      do_request

      expect(response).to have_http_status(:ok)
    end

    it 'assigns all properties' do
      do_request

      assigns(:records).should eq([@property1, @property2, @property3])
    end
  end

  describe 'GET new' do
    it 'renders the new template' do
      get :new

      expect(response).to render_template(:new)
    end

    it 'returns ok status' do
      get :new

      expect(response).to have_http_status(:ok)
    end

    it 'assigns property' do
      get :new

      expect(assigns(:property).class.name).to eq 'Property'
    end
  end

  describe 'POST create' do
    let(:parameters) { { property: { name: 'foo bar' } } }

    def do_post
      post :create, xhr: true, params: parameters
    end

    context 'with invalid parameters' do
      let(:parameters) { { property: { name: '' } } }

      it 'returns errors' do
        do_post

        expect(flash[:success]).not_to be_present
        expect(flash[:error]).to be_present
      end

      it 'redirects to new property' do
        do_post

        expect(response).to redirect_to(new_property_url)
      end
    end

    context 'with valid parameters' do
      it 'initializes the property service' do
        expect(PropertyService).to receive(:new).with(ActionController::Parameters.new(parameters).require(:property).permit(:name, :images)).and_call_original

        do_post
      end

      it 'creates the property' do
        expect_any_instance_of(PropertyService).to receive(:create).and_call_original

        do_post
      end

      it 'returns success' do
        do_post

        expect(flash[:error]).not_to be_present
        expect(flash[:success]).to be_present
      end

      it 'redirects to new property' do
        do_post

        expect(response).to redirect_to(new_property_url)
      end
    end
  end

  describe 'GET edit' do
    before do
      @property = create(:property)
    end

    it 'renders the new template' do
      get :edit, params: { id: @property.id }

      expect(response).to render_template(:edit)
    end

    it 'returns ok status' do
      get :edit, params: { id: @property.id }

      expect(response).to have_http_status(:ok)
    end

    it 'finds property' do
      expect(Property).to receive(:find).with(@property.id.to_s).and_return(@property)

      get :edit, params: { id: @property.id }
    end

    it 'assigns property' do
      get :edit, params: { id: @property.id }

      assigns(:property).should eq(@property)
    end
  end

  describe 'PUT update' do
    before do
      @property = create(:property)
    end

    def do_put
      put :update, xhr: true, params: parameters.merge(id: @property.id)
    end

    context 'with invalid parameters' do
      let(:parameters) { { property: { name: '' } } }

      it 'returns the errors' do
        do_put

        expect(flash[:success]).not_to be_present
        expect(flash[:error]).to be_present
      end

      it 'redirects to edit property' do
        do_put

        expect(response).to redirect_to(edit_property_url)
      end
    end

    context 'with valid parameters' do
      let(:parameters) { { property: { name: 'foo bar' } } }

      it 'initializes the property service' do
        expect(PropertyService).to receive(:new).with(ActionController::Parameters.new(parameters).require(:property).permit(:name, :images)).and_call_original

        do_put
      end

      it 'updates the property' do
        expect_any_instance_of(PropertyService).to receive(:update).with(@property.id.to_s).and_call_original

        do_put
      end

      it 'returns success' do
        do_put

        expect(flash[:error]).not_to be_present
        expect(flash[:success]).to be_present
      end

      it 'redirects to edit property' do
        do_put

        expect(response).to redirect_to(edit_property_url(@property))
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @property = create(:property)
    end

    def do_destroy
      delete :destroy, params: { id: @property.id }
    end

    context 'with error' do
      let(:property_service) { double(:property_service, destroy: false, success?: false, errors: ['foo']) }

      before do
        allow(PropertyService).to receive(:new).and_return(property_service)
      end

      it 'returns the errors' do
        do_destroy

        expect(flash[:success]).not_to be_present
        expect(flash[:error]).to be_present
      end

      it 'redirects to index property' do
        do_destroy

        expect(response).to redirect_to(properties_url)
      end
    end

    context 'with success' do
      it 'initializes the property service' do
        expect(PropertyService).to receive(:new).and_call_original

        do_destroy
      end

      it 'destroys the property' do
        expect_any_instance_of(PropertyService).to receive(:destroy).with(@property.id.to_s).and_call_original

        do_destroy
      end

      it 'returns success' do
        do_destroy

        expect(flash[:error]).not_to be_present
        expect(flash[:success]).to be_present
      end

      it 'redirects to index property' do
        do_destroy

        expect(response).to redirect_to(properties_url)
      end
    end
  end

  describe 'DELETE remove_image' do
    before do
      @property = create(:property)
      @property.images = [fixture_file_upload('avatar.png', 'image/png')]
      @property.save!

      @attachment = @property.images.first
    end

    def do_destroy
      delete :remove_image, params: parameters
    end

    let(:parameters) { { property_id: @property.id, attachment_id: @attachment } }
    let(:property_mock) { double(images: []) }

    it 'finds property' do
      expect(Property).to receive(:find).with(@property.id.to_s).and_return(property_mock)
      expect(property_mock.images).to receive(:find).and_return @attachment

      do_destroy
    end

    it 'destroy attachment' do
      do_destroy

      expect(@property.reload.images).to be_empty
    end

    context 'with invalid property id' do
      let(:parameters) { { property_id: '25', attachment_id: @attachment } }

      it 'returns error' do
        do_destroy

        expect(flash[:error]).to be_present
      end
    end

    it 'redirects to edit property' do
      do_destroy

      expect(response).to redirect_to(edit_property_url(@property))
    end
  end
end

require 'rails_helper'
require 'support/controller_helpers'

include ControllerHelpers

RSpec.describe PicturesController, type: :controller do
  let(:pic) { FactoryGirl.build_stubbed(:post_picture) }
  before do
    allow(PostPicture).to receive(:find).and_return(pic)
    allow(PostPicture).to receive_message_chain(:friendly, :find).and_return(pic)
    allow(PostPicture).to receive(:create).and_return(pic)
    allow_any_instance_of(PostPicture).to receive(:id).and_return(123)
    allow_any_instance_of(PostPicture).to receive(:destroy).and_return(true)
    allow_any_instance_of(PostPicture).to receive(:save).and_return(true)
    allow(pic).to receive(:save).and_return(true)
    allow(pic).to receive(:destroy).and_return(true)

    sign_in
  end

  # GET
  describe 'GET #index' do
    before { get :index }
    it 'assigns @pictures' do
      expect(assigns(:pictures)).not_to be_nil
    end
    it 'assigns @new_picture' do
      expect(assigns(:new_picture)).not_to be_nil
    end
  end

  # POST
  describe 'POST #create' do
    before { post :create, post_picture: FactoryGirl.attributes_for(:post_picture) }

    it 'redirects to index' do
      expect(response).to redirect_to(pictures_path)
    end
  end
  # PUT
  describe 'PUT #update' do
    before { post :create, id: pic.id, post_picture: FactoryGirl.attributes_for(:post_picture) }
    
    it 'redirects to index' do
      expect(response).to redirect_to(pictures_path)
    end
  end
  # DELETE
  describe 'DELETE #destroy' do
    before { delete :destroy, id: pic.id }
    
    it 'redirects to index' do
      expect(response).to redirect_to(pictures_path)
    end
  end

  context 'anauthorized access' do
    before { sign_in nil }
    it 'returns 403 on GET #index' do
      get :index
      expect(response).to be_forbidden
    end
    it 'returns 403 on POST #create' do
      post :create, post_picture: FactoryGirl.attributes_for(:post_picture)
      expect(response).to be_forbidden
    end
    it 'returns 403 on PUT #update' do
      post :create, id: pic.id, post_picture: FactoryGirl.attributes_for(:post_picture)
      expect(response).to be_forbidden
    end
    it 'returns 403 on DELETE #destroy' do
      delete :destroy, id: pic.id
      expect(response).to be_forbidden
    end
  end
end

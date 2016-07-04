require 'rails_helper'
require 'support/controller_helpers'

include ControllerHelpers

RSpec.describe PostsController, type: :controller do
  let(:pst) { FactoryGirl.build_stubbed(:post, slug: 'some-slug') }
  before do
    allow(Post).to receive_message_chain(:friendly, :find).and_return(pst)
    allow(Post).to receive(:create).and_return(pst)
    allow_any_instance_of(Post).to receive(:id).and_return(123)
    allow_any_instance_of(Post).to receive(:destroy).and_return(true)
    allow_any_instance_of(Post).to receive(:save).and_return(true)
    allow(pst).to receive(:save).and_return(true)
    allow(pst).to receive(:destroy).and_return(true)

    sign_in nil
  end

  after { Warden.test_reset! }

  # GET
  describe 'GET #show' do
    context 'with slug id' do
      before { get :show, id: pst.slug }
      it 'assigns @post' do
        expect(assigns(:post)).not_to be_nil
      end
      it 'assigns @post.pictures' do
        expect(assigns(:post).pictures).not_to be_nil
      end
      it 'assigns @see_also' do
        expect(assigns(:see_also)).not_to be_nil
      end
    end
    context 'with numeric id' do
      before { get :show, id: pst.id }
      it 'redirects to slug' do
        expect(response).to redirect_to(post_path(pst))
      end
    end
  end

  describe 'GET #index' do
    before { get :index }
    it 'assigns @posts' do
      expect(assigns(:posts)).not_to be_nil
    end
    it 'assigns @tags' do
      expect(assigns(:tags)).to eq ActsAsTaggableOn::Tag.most_used(50)
    end
  end

  describe 'GET #new' do
    context 'when authorized' do
      before { sign_in }
      it 'assigns @post' do
        get :new
        expect(assigns(:post)).not_to be_nil
      end
    end
    it 'returns FORBIDDEN' do
      get :new
      expect(response).to be_forbidden
    end
  end

  describe 'GET #edit' do
    context 'when authorized' do
      before { sign_in }
      it 'assigns @post' do
        get :edit, id: pst
        expect(assigns(:post)).not_to be_nil
      end
    end
    it 'returns FORBIDDEN' do
      get :edit, id: pst
      expect(response).to be_forbidden
    end
  end

  describe 'GET #preview' do
    context 'when authorized' do
      before { sign_in }
      it 'renders text' do
        get :preview, post: { text: '# Some Markdown' }
        expect(response.body).to match %r{<h1>Some Markdown</h1>}
      end
    end
    it 'returns FORBIDDEN' do
      get :preview, post: { text: '# Some Markdown' }
      expect(response).to be_forbidden
    end
  end

  # POST
  describe 'POST #create' do
    context 'when authorized' do
      before { sign_in }
      before { post :create, post: FactoryGirl.attributes_for(:post, slug: 'some-slug') }
      it 'assigns @post' do
        expect(assigns(:post)).not_to be_nil
      end
      it 'redirects to post' do
        expect(response).to redirect_to(post_path(pst))
      end
    end
    it 'returns FORBIDDEN' do
      post :create, post: FactoryGirl.attributes_for(:post, slug: 'some-slug')
      expect(response).to be_forbidden
    end
  end

  # PUT
  describe 'PUT #update' do
    context 'when authorized' do
      before { sign_in }
      before { post :update, id: pst, post: FactoryGirl.attributes_for(:post, text: 'new text', slug: 'some-slug') }
      it 'assigns @post' do
        expect(assigns(:post)).not_to be_nil
      end
      it 'redirects to post' do
        expect(response).to redirect_to(post_path(pst))
      end
    end
    it 'returns FORBIDDEN' do
      post :update, id: pst, post: FactoryGirl.attributes_for(:post, text: 'new text', slug: 'some-slug')
      expect(response).to be_forbidden
    end
  end

  # DELETE
  describe 'DELETE #destroy' do
    context 'when authorized' do
      before { sign_in }
      before { delete :destroy, id: pst }
      it 'assigns @post' do
        expect(assigns(:post)).not_to be_nil
      end
      it 'redirects to index' do
        expect(response).to redirect_to(posts_path)
      end
    end

    it 'returns FORBIDDEN' do
      delete :destroy, id: pst
      expect(response).to be_forbidden
    end
  end
end

require 'rails_helper'

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
  end

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
      expect(assigns(:tags)).not_to be_nil
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'assigns @post' do
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: pst }
    it 'assigns @post' do
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe 'GET #preview' do
    before { get :preview, post: { text: '# Some Markdown' } }
    it 'renders text' do
      expect(response.body).to match %r{<h1>Some Markdown</h1>}
    end
  end

  # POST
  describe 'POST #create' do
    before { post :create, post: FactoryGirl.attributes_for(:post, slug: 'some-slug') }
    it 'assigns @post' do
      expect(assigns(:post)).not_to be_nil
    end
    it 'redirects to post' do
      expect(response).to redirect_to(post_path(pst))
    end
  end

  # PUT
  describe 'PUT #update' do
    before { post :update, id: pst, post: FactoryGirl.attributes_for(:post, text: 'new text', slug: 'some-slug') }
    it 'assigns @post' do
      expect(assigns(:post)).not_to be_nil
    end
    it 'redirects to post' do
      expect(response).to redirect_to(post_path(pst))
    end
  end

  # DELETE
  describe 'DELETE #destroy' do
    before { delete :destroy, id: pst }
    it 'assigns @post' do
      expect(assigns(:post)).not_to be_nil
    end
    it 'redirects to index' do
      expect(response).to redirect_to(posts_path)
    end
  end
end

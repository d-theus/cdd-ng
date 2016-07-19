require 'rails_helper'
require 'support/controller_helpers'

include ControllerHelpers

RSpec.describe ContactsController, type: :controller do
  let(:contact) { FactoryGirl.build_stubbed(:contact, id: 123) }

  before do
    allow_any_instance_of(Contact).to receive(:destroy).and_return(true)
    allow(Contact).to receive(:find).with(contact.id.to_s).and_return(contact)

    allow(Rails.application).to receive_message_chain(:routes, :url_helpers, :contacts_path).and_return('/contacts')
    allow(Rails.application).to receive_message_chain(:routes, :url_helpers, :about_path).and_return('/about')

    class ContactsController
      def about_path
        '/about'
      end
    end

    def about_path
      '/about'
    end

    sign_in nil
  end

  after { Warden.test_reset! }

  describe 'GET #index' do
    let(:req) { get :index }
    context 'when anonymous' do
      it 'returns FORBIDDEN' do
        req
        expect(response).to be_forbidden
      end
    end
    context 'when authenticated' do
      before { sign_in }

      it 'returns OK' do
        req
        expect(response).to be_ok
      end
    end
  end

  describe 'GET #new' do
    let(:req) { get :new }
    context 'when anonymous' do
      it 'returns OK' do
        req
        expect(response).to be_ok
      end
    end
  end

  describe 'POST #create' do
    let(:good_attrs) { FactoryGirl.attributes_for(:contact) }
    let(:bad_attrs) { FactoryGirl.attributes_for(:contact, reply: nil) }
    let(:attrs) { good_attrs }
    let(:req) { post :create, contact: attrs }
    context 'when anonymous' do
      context 'when good contact' do
        it 'redirects_to about_path' do
          req
          expect(response).to redirect_to about_path
        end

        it 'has notice' do
          req
          expect(flash[:notice]).not_to be_nil
        end
      end
      context 'when bad contact' do
        let(:attrs) { bad_attrs }
        it 'has invalid record' do
          req
          expect(assigns[:contact]).to be_invalid
        end
        it 'is UNPROCESSABLE ENTITY' do
          req
          expect(response).not_to be_success
        end
        it 'renders :new' do
          req
          expect(response).to render_template(:new)
        end
        it 'has flash alert' do
          req
          expect(flash[:alert]).not_to be_nil
        end
      end
    end
  end

  describe 'PUT update' do
    let(:req) { put :update, format: :js, id: contact.id, contact: attrs }
    let(:attrs) { { unread: false } }
    before { allow(contact).to receive(:save).and_return(true) }
    context 'when anonymous' do
      it 'returns FORBIDDEN' do
        req
        expect(response).to be_forbidden
      end
    end

    context 'when authenticated' do
      before { sign_in }
      context 'with bad params' do
        let(:attrs) { { name: 'other' } }
        it 'succeeds' do
          req
          expect(response).to be_success
        end

        it 'does not change anything' do
          expect { req }.not_to change { contact.name }
          expect { req }.not_to change { contact.unread }
        end
      end

      context 'with good params' do
        it 'returns ok' do
          req
          expect(response).to be_success
        end

        it 'calls save' do
          expect { req }.to change { contact.unread }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:contact) { FactoryGirl.create(:contact) }
    let(:format) { 'html' }
    let(:req) { delete :destroy, id: contact.id, format: format }
    context 'when anonymous' do
      it 'returns FORBIDDEN' do
        req
        expect(response).to be_forbidden
      end
    end
    context 'when authenticated' do
      before { sign_in }

      context 'when .js' do
        let(:format) { :js }
        it 'returns OK' do
          req
          expect(response).to be_ok
        end
      end
      context 'when .html' do
        it 'redirects to contacts_path' do
          req
          expect(response).to redirect_to contacts_path
        end

        it 'has notice' do
          req
          expect(flash[:notice]).not_to be_nil
        end
      end
    end
  end
end

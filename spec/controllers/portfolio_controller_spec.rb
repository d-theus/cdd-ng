require 'rails_helper'
require 'support/controller_helpers'

include ControllerHelpers

RSpec.describe PortfolioController, type: :controller do
  let(:work) { FactoryGirl.build_stubbed(:work, id: 123) }
  before do
    allow_any_instance_of(Work).to receive(:destroy).and_return(true)
    allow_any_instance_of(Work).to receive(:save).and_return(true)
    allow(Work).to receive(:create).and_return(work)
    allow(Work).to receive(:destroy).and_return(true)
    allow(Work).to receive(:find).with(work.id.to_s).and_return(work)
    allow(work).to receive(:save).and_return(true)
    allow(work).to receive(:destroy).and_return(true)

    sign_in nil
  end

  after { Warden.test_reset! }

  describe 'GET #show' do
    before { get :show }
    it 'has status OK' do
      expect(response).to be_ok
    end
    it 'assings works' do
      expect(assigns[:works]).not_to be_nil
    end
  end

  describe 'POST #create' do
    context 'when authorized' do
      before { sign_in }
      it 'redirects to portfolio_path' do
        post :create, work: FactoryGirl.attributes_for(:work)
        expect(response).to redirect_to portfolio_path
      end
    end
    context 'when unauthorized' do
      it 'returns FORBIDDEN' do
        post :create, work: FactoryGirl.attributes_for(:work)
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PUT #update' do
    context 'when authorized' do
      before { sign_in }
      it 'redirects to portfolio :show' do
        put :update, id: work.id, work: FactoryGirl.attributes_for(:work, title: 'other')
        expect(response).to redirect_to portfolio_path
      end
    end
    context 'when unauthorized' do
      it 'returns FORBIDDEN' do
        put :update, id: work.id, work: FactoryGirl.attributes_for(:work, title: 'other')
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destoy' do
    context 'when authorized' do
      before { sign_in }
      it 'redirects to portfolio :show' do
        delete :destroy, id: work.id
        expect(response).to redirect_to portfolio_path
      end
    end
    context 'when unauthorized' do
      it 'returns FORBIDDEN' do
        delete :destroy, id: work.id
        expect(response).to be_forbidden
      end
    end
  end
end

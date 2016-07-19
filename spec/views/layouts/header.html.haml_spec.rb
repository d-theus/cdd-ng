require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'layouts/_header', type: :view do
  include Capybara::DSL
  before { allow(view).to receive(:admin?).and_return(false) }

  it 'has portfolio link pointing to /portfolio' do
    render text: '', layout: 'layouts/application'
    expect(response).to have_link('Portfolio', href: '/portfolio')
  end

  describe 'Contacts link' do
    context 'when anonymous' do
      it 'has no link' do
        render text: '', layout: 'layouts/application'
        expect(response).not_to have_link('Contacts')
      end
    end
    context 'when authorized' do
      before { allow(view).to receive(:admin?).and_return(true) }

      it 'has link' do
        render text: '', layout: 'layouts/application'
        expect(response).to have_link('Contacts', href: contacts_path)
      end

      context 'with no messages existing' do
        before { assign('contacts_count', 0) }
        it 'has no unread label in case there are no unread messages' do
          render text: '', layout: 'layouts/application'
          expect(response).to have_content('Contacts 0')
        end
      end
      context 'with messages' do
        before { assign('contacts_count', 10) }
        it 'has unread label in case there are unread messages' do
          render text: '', layout: 'layouts/application'
          expect(response).to have_content('10')
        end
      end
    end
  end
end

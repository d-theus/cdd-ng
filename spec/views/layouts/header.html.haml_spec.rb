require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'layouts/_header', type: :view do
  include Capybara::DSL
  before { allow(view).to receive(:admin?).and_return(false) }

  it 'has portfolio link pointing to /portfolio' do
    render text: '', layout: 'layouts/application'
    expect(response).to have_link('Portfolio', href: '/portfolio')
  end
end

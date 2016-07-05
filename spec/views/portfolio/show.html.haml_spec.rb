require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "portfolio/show", type: :view do
  let(:works) do
    WorkListDecorator.new(
      Array.new(works_count) do |i|
        FactoryGirl.build_stubbed(:work, title: "work#{i}")
      end, 
      ApplicationController.new.view_context
    )
  end
  let(:works_count) { 10 }
  before do
    assign :works, works
    allow(view).to receive(:admin?).and_return(false)
  end

  it 'has content_for :page_heading' do
    render
    expect(view.content_for(:page_heading)).to have_selector('h1', text: 'Portfolio')
  end
  describe 'content_for :action' do
    context 'when authenticated' do
      before { allow(view).to receive(:admin?).and_return(true) }
      it 'has "add button"' do
        render
        expect(view.content_for(:action)).to have_selector('a#new_work_link')
      end
      it 'has no "contact" button' do
        render
        expect(view.content_for(:action)).not_to have_selector('a#contact_link')
      end
    end
    context 'when anonymous' do
      before { allow(view).to receive(:admin?).and_return(false) }
      it 'has no "add" button' do
        render
        expect(view.content_for(:action)).not_to have_selector('a#new_work_link')
      end
      it 'has "contact" button' do
        render
        expect(view.content_for(:action)).to have_selector('a#contact_link')
      end
    end
  end
  describe 'work entries' do
    it 'has :works_count entries' do
      render
      expect(response).to have_selector('.work', count: works_count)
    end
  end
end

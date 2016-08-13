require 'rails_helper'

def decorate_list(list)
  CommentListDecorator.new(list, ApplicationController.new.view_context)
end

RSpec.describe "comments/index", type: :view do
  let(:pst) { FactoryGirl.build_stubbed(:post, id: 1, slug: 'slug') }
  let(:count) { 1 }
  before do
    assign(:post, pst)
    pst.comments = FactoryGirl.build_list(:comment, count)
    assign(:comments, decorate_list(pst.comments))
  end

  context 'when no comments' do
    let(:count) { 0 }
    
    it 'has empty ul' do
      render
      expect(rendered).to have_selector('ul')
      expect(rendered).not_to have_selector('li')
    end
  end

  context 'when there are comments' do
    let(:count) { 10 }
    
    it 'has items' do
      render
      expect(rendered).to have_selector('ul')
      # remember about li.separator !
      expect(rendered).to have_selector('li', count: (2 * count - 1))
    end
  end
end


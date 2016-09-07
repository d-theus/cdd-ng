require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'posts/show', type: :view do
  include Capybara::DSL
  let(:pst) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_pictures, tag_list: ['tag1', 'tag2'], slug: 'slug'), ApplicationController.new.view_context) }
  let(:see_also) { Array.new(3) { FactoryGirl.build_stubbed(:post, slug: 'someslug') } }

  before do
    assign :post, pst
    assign :see_also, see_also
  end

  before { allow(view).to receive(:admin?).and_return(false) }

  it 'has content_for :page_heading block with h1 in it' do
    render
    expect(view.content_for(:page_heading)).to have_content(/#{pst.title}/)
  end

  it 'has images' do
    render
    expect(response).to have_selector('img')
  end

  it 'has tags section' do
    render
    expect(rendered).to have_content('Tagged:')
    expect(rendered).to have_content('tag1')
    expect(rendered).to have_content('tag2')
  end

  it 'has see also section' do
    render
    expect(rendered).to have_content('See also')
    expect(rendered).to have_content(see_also.first.title)
    expect(rendered).to have_content(see_also.last.title)
  end

  it 'has SHOW COMMENTS link' do
    render
    expect(rendered).to have_content('SHOW COMMENTS')
    expect(response).to have_selector("a[href=\"#{post_comments_path(view.assigns[:post])}\"]")
  end

  context 'when admin signed in' do
    before { allow(view).to receive(:admin?).and_return(true)}
    it 'has action button "create new post"' do
      render
      expect(view.content_for(:action)).to have_content(/edit/i)
    end
  end
  it 'has action button share' do
    render
    expect(view.content_for(:action)).to have_content(/share/i)
  end
end

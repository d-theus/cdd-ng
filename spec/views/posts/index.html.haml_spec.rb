require 'rails_helper'
require 'will_paginate/array'

RSpec.describe "posts/index", type: :view do
  let(:posts) do
    PostListDecorator.new(
      Array.new(post_count) do |i|
        FactoryGirl.build_stubbed(:post, i % 3 == 0 ? :with_picture : nil)
      end.paginate(per_page: per_page),
      ApplicationController.new.view_context
    )
  end
  let(:tags) { Array.new(10) { FactoryGirl.build_stubbed(:tag) } }
  let(:per_page) { 10 }
  let(:post_count) { 10 }

  before do
    assign :posts, posts
    assign :tags,  tags
  end

  it 'has content_for :page_heading' do
    render
    expect(view.content_for(:page_heading)).to have_selector('h1', text: 'Recent posts')
  end

  describe 'content_for :action' do
    context 'when admin' do
      before { allow(view).to receive(:admin?).and_return(true)}
      it 'has create button' do
        render
        expect(view.content_for(:action)).to have_selector('a')
      end
    end
    context 'when anon' do
      before { allow(view).to receive(:admin?).and_return(false)}
      it 'has nothing' do
        render
        expect(view.content_for(:action)).to be_nil
      end
    end
  end

  describe 'pagination' do
    context 'when there are less than :per_page posts' do
      let(:post_count) { per_page - 1 }
      it 'is absent' do
        render
        expect(response).not_to have_css('.pager')
      end
    end
    context 'when there are more than :per_page posts' do
      let(:post_count) { per_page + 1 }
      it 'is present' do
        render
        expect(response).to have_css('.pager')
      end
    end
  end

  describe 'posts entries' do
    it "has exactly the number of .post's" do
      render
      expect(response).to have_selector('.list-group-item', count: posts.size)
    end
    it 'has dates' do
      render
      expect(response).to have_content(Time.now.strftime('%-d %b, %Y'))
    end
    context 'when admin' do
      before { allow(view).to receive(:admin?).and_return(true)}
      it 'has EDIT links' do
        render
        expect(response).to have_content('EDIT')
      end
    end
    context 'when anon' do
      before { allow(view).to receive(:admin?).and_return(false)}
      it 'has no EDIT links' do
        render
        expect(response).not_to have_content('EDIT')
      end
    end
  end
end

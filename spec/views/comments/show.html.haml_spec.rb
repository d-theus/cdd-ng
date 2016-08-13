require 'rails_helper'

def build_decorator(*args)
  CommentDecorator.new(FactoryGirl.build_stubbed(*args), ApplicationController.new.view_context)
end

RSpec.describe "comments/_show", type: :view do
  let(:comment) { build_decorator(:comment) }
  let(:locals) { { comment: comment } }
  let(:_render) { render partial: 'comments/show', layout: false, locals: locals }

  it 'has name' do
    _render
    expect(rendered).to have_content(comment.name)
  end

  context 'when there is profile_link' do
    let(:comment) { build_decorator(:comment, profile_link: 'https://github.com/d-theus') }
    it 'has profile link' do
      _render
      expect(rendered).to have_selector('a')
    end
  end
  context 'when no profile_link' do
    let(:comment) { build_decorator(:comment, profile_link: nil) }
    it 'has no profile link' do
      _render
      expect(rendered).not_to have_selector('a')
    end
  end
  context 'when no avatar' do
    let(:comment) { build_decorator(:comment, avatar_url: '') }
    it 'has placeholder' do
      _render
      expect(rendered).to have_selector('i.material-icons')
    end
  end
  context 'when there is an avatar' do
    let(:avatar_url) { 'http://example.com/avatars/my' }
    let(:comment) { build_decorator(:comment, avatar_url: avatar_url) }
    it 'has img' do
      _render
      expect(rendered).to have_selector('img')
    end
  end
  it 'surely has text' do
    _render
    expect(rendered).to have_content(comment.text)
  end

  describe 'timestamp' do
    let(:time) { Time.now }
    let(:comment) { build_decorator(:comment, created_at: time) }

    it 'is in place and properly set' do
      _render
      expect(rendered).to have_content(time.strftime('%-d %b, %Y'))
    end
  end
end


require 'rails_helper'
require 'capybara/rspec'
include Capybara::RSpecMatchers

RSpec.describe PostDecorator, type: :model do
  let(:vctx) { c = ActionController::Base.new.view_context }
  describe '#thumb' do
    context 'when 0 pictures' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post), vctx) }

      it 'renders placeholder' do
        expect(dec.thumb).to have_css('i.material-icons')
      end
    end
    context 'when 1 picture' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_picture), vctx) }

      it 'renders pictures' do
        expect(dec.thumb).to have_selector('img.circle', count: 1)
      end
    end
    context 'when >1 pictures' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_pictures), vctx) }

      it 'renders first picture' do
        expect(dec.thumb).to have_selector('img', count: 1)
      end
    end
  end
  describe '#tags' do
    context 'when 0 tags' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_tags, tags_count: 0), vctx) }

      it 'renders empty ul' do
        expect(dec.tags).to have_selector('ul.tags')
        expect(dec.tags).not_to have_selector('ul.tags li')
      end
    end
    context 'when 1 tag' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_tags, tags_count: 1), vctx) }

      it 'renders 1 tag as <a>' do
        expect(dec.tags).to have_selector('ul.tags li a', text: /tag\d+/, count: 1)
      end
    end
    context 'when >1 tags' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, :with_tags, tags_count: 3), vctx) }

      it 'renders tags as comma-separated <a>\'s' do
        expect(dec.tags).to have_selector('ul.tags li a', text: /tag\d+/, count: 3)
      end
    end
  end
  describe '#summary' do
    context 'when has cut tag' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, text: "before cut\n<!--cut-->some more text"), vctx) }

      it 'renders just before tag' do
        expect(dec.summary).to have_content("before cut")
        expect(dec.summary).not_to have_content("some")
      end
    end
    context 'when has no cut tag' do
      let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, text: 'no cut'), vctx) }

      it 'renders nothing' do
        expect(dec.summary).to be_blank
      end
    end
  end
  describe '#render' do
    let(:dec) { PostDecorator.new(FactoryGirl.build_stubbed(:post, text: "before cut\n<!--cut-->some more text\r\n\r\n* also list\n* one more item\n"), vctx) }

    it 'renders whole post text' do
      expect(dec.render).to have_selector 'ul'
      expect(dec.render).to have_selector 'li', count: 2
      expect(dec.render).not_to have_content  '-cut-'
    end
  end

  describe 'share buttons' do
    let(:title) { 'Post title' }
    let(:pst) { FactoryGirl.build_stubbed(:post, title: title, slug: 'slug', id: 1) }
    let(:dec) { PostDecorator.new(pst, vctx) }

    describe '#share_with_facebook_button' do
      let(:app_id) { id = Rails.application.secrets.facebook_app_id || fail("Set facebook app_id"); id.to_s }
      before { ENV['FACEBOOK_APP_ID'] = app_id.to_s }

      it 'outputs valid button' do
        expect(dec.share_with_facebook_button).to have_css("a[href^='https://facebook.com/dialog/share']")
        expect(dec.share_with_facebook_button).to match /href=#{CGI.escape post_url(pst)}/
        expect(dec.share_with_facebook_button).to match /redirect_url=#{CGI.escape post_url(pst)}/
        expect(dec.share_with_facebook_button).to match /app_id=#{CGI.escape app_id}/
      end
    end

    describe '#share_with_twitter_button' do
      it 'outputs valid button' do
        expect(dec.share_with_twitter_button).to have_css("a[href^='https://twitter.com/intent/tweet']")
        expect(dec.share_with_twitter_button).to include "text=#{CGI.escape pst.title}"
        expect(dec.share_with_twitter_button).to match /url=#{CGI.escape post_url(pst)}/
      end
    end

    describe '#share_with_vk_button' do
      it 'outputs valid button' do
      end
    end
  end

  describe 'social meta information' do
    let(:title) { 'Post title' }
    let(:summary) { 'summary here' }
    let(:text) do
      <<-EOF
      #{summary}

      <--cut-->

      main content
      EOF
    end
    let(:summary) { }
    let(:pst) { FactoryGirl.build_stubbed(:post, title: title, slug: 'slug', text: text, id: 1) }
    let(:dec) { PostDecorator.new(pst, vctx) }

    describe 'OG' do
      let(:app_id) { id = Rails.application.secrets.facebook_app_id || fail("Set facebook app_id"); id.to_s }

      it 'has [fb:app_id]' do
        expect(dec.meta_for_facebook).to have_selector %(meta[property="fb:app_id"][content="#{app_id}"]), visible: false
      end
      it 'has [og:*]' do
        expect(dec.meta_for_facebook).to have_selector %(meta[property="og:type"][content="article"]), visible: false
        expect(dec.meta_for_facebook).to have_selector %(meta[property="og:url"][content="#{post_url(pst)}"]), visible: false
        expect(dec.meta_for_facebook).to have_selector %(meta[property="og:title"][content="#{pst.title}"]), visible: false
        expect(dec.meta_for_facebook).to have_selector %(meta[property="og:image"][content="#{image_url "logo.svg"}"]), visible: false
        expect(dec.meta_for_facebook).to have_selector %(meta[property="og:description"][content="#{pst.summary}"]), visible: false
      end
    end

    describe 'twitter' do
      it 'has [twitter:*]' do
        expect(dec.meta_for_twitter).to have_selector %(meta[name="twitter:card"][content="summary"]), visible: false
        expect(dec.meta_for_twitter).to have_selector %(meta[name="twitter:site"][content="@cddevel"]), visible: false
        expect(dec.meta_for_twitter).to have_selector %(meta[name="twitter:title"][content="#{pst.title}"]), visible: false
        expect(dec.meta_for_twitter).to have_selector %(meta[name="twitter:description"][content="#{pst.summary}"]), visible: false
        expect(dec.meta_for_twitter).to have_selector %(meta[name="twitter:image"][content="#{image_url "logo.svg"}"]), visible: false
      end
    end
  end
end

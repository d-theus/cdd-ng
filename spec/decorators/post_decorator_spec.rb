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
end

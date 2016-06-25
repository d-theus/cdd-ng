require 'rails_helper'
require 'capybara/rspec'
include Capybara::RSpecMatchers

RSpec.describe PostListDecorator, type: :model do
  let(:vctx) { c = ActionController::Base.new.view_context }
  subject(:dec) { PostListDecorator.new(posts, vctx) }
  let(:posts) { FactoryGirl.build_list(:post, 20) }

  it 'decorates items' do
    expect(dec.first).to be_a PostDecorator
    expect(dec.last).to be_a PostDecorator
  end

  describe 'will_paginate methods' do
    let(:obj)   { double dec.instance_variable_get(:@object) }

    before do
      allow(obj).to receive_messages(
        total_pages: 0,
        current_page: 0,
        limit_value: 0
      )
      dec.instance_variable_set(:@object, obj)
    end

    describe '#total_pages' do
      it 'calls object\'s method' do
        expect(obj).to receive(:total_pages)
        dec.total_pages
      end
    end
    describe '#current_page' do
      it 'calls object\'s method' do
        expect(obj).to receive(:current_page)
        dec.current_page

      end
    end
    describe '#limit_value' do
      it 'calls object\'s method' do
        expect(obj).to receive(:limit_value)
        dec.limit_value
      end
    end
  end
end

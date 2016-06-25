require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PostsHelper, type: :helper do
  before { helper.extend(Haml::Helpers) }
  before { helper.extend(ActionView::Helpers) }
  before { helper.init_haml_helpers }

  let(:post_with_no_tags) { FactoryGirl.build_stubbed(:post) }
  let(:post_with_tags) { FactoryGirl.build_stubbed(:post, tag_list: ['tag1', 'tag2']) }
  let(:post_with_no_picture) { FactoryGirl.build_stubbed(:post) }
  let(:post_with_one_picture) { FactoryGirl.build_stubbed(:post, :with_picture) }
  let(:post_with_many_pictures) { FactoryGirl.build_stubbed(:post, :with_pictures) }

  describe '#post_thumb' do
    context 'when post has exactly one image' do
      it 'renders the only image' do
        expect(helper.post_thumb(post_with_one_picture)).to match /<img/
        expect(helper.post_thumb(post_with_one_picture)).to match /class=.circle./
        expect(helper.post_thumb(post_with_one_picture)).to match /src=.#{post_with_one_picture.pictures.first.image.thumb}./
      end
    end
    context 'when post has more than one image' do
      it 'renders first image' do
        expect(helper.post_thumb(post_with_one_picture)).to match /<img/
        expect(helper.post_thumb(post_with_one_picture)).to match /class=.circle./
        expect(helper.post_thumb(post_with_one_picture)).to match /src=.#{post_with_one_picture.pictures.first.image.thumb}./
      end
    end
    context 'when post has no images' do
      it 'renders placeholder' do
        expect(helper.post_thumb(post_with_one_picture)).not_to match /<i\s/
        expect(helper.post_thumb(post_with_one_picture)).not_to match /note/
      end
    end
  end

  describe '#post_tags' do
    context 'when post has no tags' do
      it 'renders no li\'s' do
        expect(helper.post_tags(post_with_no_tags)).to be_blank
      end
    end
    context 'when there are tags' do
      let(:rendered) { helper.post_tags(post_with_tags) }
      it 'renders li\'s with links' do
        $stderr.puts rendered
        expect(rendered).to have_selector('li', count: post_with_tags.tag_list.size)
        expect(rendered).to have_selector('a', count: post_with_tags.tag_list.size)
        post_with_tags.tag_list.each do |t|
          expect(rendered).to have_selector('a', text: t.to_s)
        end
      end
    end
  end
  describe '#render_post_text' do
    it 'renders markdown' do
      expect(helper.render_post_text("# This is markdown")).to match %r{<h1>This is markdown</h1>}
    end
  end
end

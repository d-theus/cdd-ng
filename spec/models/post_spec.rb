require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations:' do
    describe 'constraints' do
      describe 'title' do
        it 'cannot be empty' do
          expect(FactoryGirl.build(:post, title: nil)).not_to be_valid
        end
      end
      describe 'text' do
        it 'cannot be empty' do
          expect(FactoryGirl.build(:post, text: nil)).not_to be_valid
        end
      end
      describe 'slug' do
        describe 'generation' do
          before { Post.delete_all }
          context 'with explicit slug' do
            let(:post) { Post.create(title: 'Some Title', slug: 'my-slug') }
            it 'is not being generated' do
              expect(post.slug).to match /my-slug/
            end
          end
          context 'with implicit slug' do
            let(:post) { FactoryGirl.create(:post, title: 'Some Other Title') }
            it 'is being generated' do
              expect(post.reload.slug).to match /some-other-title/
            end
          end
        end
      end
    end
  end

  describe 'hooks:' do
    describe 'pictures:' do
      let(:post) { FactoryGirl.create(:post) }
      let(:pic)  { FactoryGirl.create(:post_picture) }
      it 'updates pictures association when changed' do
        expect do
          post.update(text:<<-EOF
This is example text.
<!--cut-->
Image:
[#{pic.caption}](#{pic.slug} "#{pic.caption}")
some more text
EOF
          )
        end.to change(post.pictures, :count).by(1)
      end
    end
  end
  describe 'constraints:' do
    describe 'pictures:' do
      let(:post) { FactoryGirl.create(:post, :with_pictures) }
      before { post.reload }
      it 'removes pictures association cascade' do
        expect do
          post.destroy
        end.to change { PostPicture.joins('JOIN "posts_post_pictures" ON post_pictures.id = posts_post_pictures.post_picture_id').count }
      end
    end
  end

  # Methods
  describe '#summary' do
    context 'when there is no tag' do
      it 'is empty' do
        expect(FactoryGirl.build(:post, text: 'This is some text, no cut tag here').summary).to be_blank
      end
    end
    context 'when there is tag present' do
      it 'is part before <!--cut-->' do
        expect(FactoryGirl.build(:post, text: "This is text before cut.\n<!--cut-->This is text after cut.").summary).to eq "This is text before cut.\n"
      end
    end
  end
end

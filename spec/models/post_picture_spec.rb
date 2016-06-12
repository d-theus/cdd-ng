require 'rails_helper'

RSpec.describe PostPicture, type: :model do
  describe 'validations:' do
    describe 'caption' do
      it 'is not mandatory' do
        expect(FactoryGirl.build(:post_picture, caption: nil)).to be_valid
      end
    end
    describe 'slug' do
      describe 'generation' do
        before { PostPicture.delete_all }
        context 'with explicit slug' do
          let(:pic) { FactoryGirl.create(:post_picture, caption: 'Caption', slug: 'my-slug') }
          it 'is not being generated' do
            expect(pic.slug).to match /my-slug/
          end
        end
        context 'with implicit slug' do
          let(:post) { FactoryGirl.create(:post_picture, caption: 'Some Other Caption') }
          it 'is being generated' do
            expect(post.reload.slug).to match /some-other-caption/
          end
        end
      end
    end
  end
  describe 'hooks:' do
    
  end
end


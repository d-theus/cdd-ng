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
![#{pic.caption}](#{pic.slug} "#{pic.caption}")
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
        expect(post.pictures.count).to be > 0
        expect do
          post.destroy
        end.to change { PostPicture.joins('JOIN "posts_post_pictures" ON post_pictures.id = posts_post_pictures.post_picture_id').count }
      end
    end
  end

  # Scopes
  describe 'scope' do
    before { FactoryGirl.create_list(:post, count) }
    let(:per_page) { 10 }
    let(:count) { 15 }

    describe '#recent' do
      it 'has :per_page records' do
        expect(Post.recent.size).to eq 10
      end

      it 'has records sorted by :created_at' do
        times = Post.recent.map(&:created_at)
        expect(times).to eq times.sort.reverse
      end

      it 'last page has :count % :per_page records' do
        page = Post.recent.total_pages
        expect(Post.recent(page: page).size).to eq (count % per_page)
      end
    end

    describe '#tagged' do
      before { Post.find_each { |p| p.update(tag_list: %w[tag1 tag2 tag3]) } }
      before { Post.last.update(tag_list: %w[tag1 tag2 tag3 tag4]) }
      
      it 'returns empty collection when absent tag given' do
        expect(Post.tagged(tag: 'tag10')).to be_empty
      end
      it 'returns exactly the posts tagged, paginated' do
        expect(Post.tagged(tag: 'tag1').size).to eq per_page
        page = Post.tagged(tag: 'tag1').total_pages
        expect(Post.tagged(tag: 'tag1', page: page).size).to eq (count % per_page)
      end
    end

    describe '#search' do
      before(:all) { Post.create(title: 'Post1', tag_list: %w[tag1], text: 'lorem') }
      before(:all) { Post.create(title: 'Post2', tag_list: %w[tag2], text: 'ipsum') }
      before(:all) { Post.create(title: 'Post3', tag_list: %w[tag3], text: 'dolor') }
      subject { Post.search query: query }

      context 'when query' do
        context 'is empty' do
          let(:query) { '' }
          it 'returns empty collection' do
            expect(subject).to be_empty
          end
        end
        context 'mathes title, tags, text [---]' do
          let(:query) { 'nope, nah, noway' }
          it 'returns empty collection' do
            expect(subject).to be_empty
          end
        end
        context 'mathes title, tags, text [--v]' do
          let(:query) { 'lorem ipsum' }
          it 'return all matched' do
            expect(subject.size).to eq 2
            expect(subject.select {|rec| rec.title == 'Post1' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post2' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
        context 'mathes title, tags, text [-v-]' do
          let(:query) { 'tag1 tag2' }
          it 'return all matched' do
            expect(subject.size).to eq 2
            expect(subject.select {|rec| rec.title == 'Post1' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post2' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
        context 'mathes title, tags, text [-vv]' do
          let(:query) { 'lorem tag2' }
          it 'return all matched, tags first' do
            expect(subject.size).to eq 2
            expect(subject[0].title).to eq 'Post2'
            expect(subject[1].title).to eq 'Post1'
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
        context 'mathes title, tags, text [v--]' do
          let(:query) { 'Post1 Post2' }
          it 'return all matched' do
            expect(subject.size).to eq 2
            expect(subject.select {|rec| rec.title == 'Post1' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post2' }.size).to eq 1
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
        context 'mathes title, tags, text [v-v]' do
          let(:query) { 'lorem Post2' }
          it 'return all matched, title first' do
            expect(subject.size).to eq 2
            expect(subject[0].title).to eq 'Post2'
            expect(subject[1].title).to eq 'Post1'
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
        context 'mathes title, tags, text [vv-]' do
          let(:query) { 'lorem Post2' }
          it 'return all matched, title first' do
            
          end
        end
        context 'mathes title, tags, text [vvv]' do
          let(:query) { 'lorem Post2 tag1' }
          it 'return all matched, title first, tag second' do
            expect(subject.size).to eq 2
            expect(subject[0].title).to eq 'Post2'
            expect(subject[1].title).to eq 'Post1'
            expect(subject.select {|rec| rec.title == 'Post3' }.size).to eq 0
          end
        end
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

  describe '#related_posts' do
    subject { FactoryGirl.create(:post, tag_list: %(tag1 tag2 tag3)) }
    it 'returns an enumerable' do
      expect(subject.related).to respond_to(:each)
    end
    context 'with other posts available' do
      before do
        Post.delete_all
        5.times do |i|
          FactoryGirl.create(:post, tag_list: [*1..5].take(i + 1), slug: "post-#{i}")
        end
      end

      context 'with no tags' do
        subject { FactoryGirl.create(:post, tag_list: []) }
        it 'returns no posts' do
          expect(subject.related).to be_empty
        end
      end
      context 'with some tags' do
        it 'returns posts based on similar tags' do
          expect(subject).to receive(:find_related_tags)
          subject.related
        end
      end
    end
  end
end

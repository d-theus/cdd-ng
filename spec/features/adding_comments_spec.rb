require 'rails_helper'

RSpec.feature "AddingComments", type: :feature, js: true do
  let(:pst) { Post.delete_all; FactoryGirl.create(:post, slug: 'slug') }
  let(:comment_count) { 10 }
  before do
    pst.reload
    comment_count.times { FactoryGirl.create(:comment, post_id: pst.id) }
  end

  context 'with valid comment' do
    scenario 'creating comment' do
      visit "/blog/posts/#{pst.slug}"

      click_link 'SHOW COMMENTS'

      expect(page).to have_text 'Comments'
      expect(page).to have_selector('li[id^="comment-"]', count: comment_count)

      click_link 'ADD A COMMENT'

      expect(page).to have_text 'New comment'

      expect(page).to have_selector('li[id^="comment-"]', count: comment_count)
      fill_in 'Name', with: 'Andy'
      fill_in 'Text', with: 'Great post!'
      fill_in 'Avatar url', with: 'http://example.com/image.jpg'
      fill_in 'Profile link', with: 'https://github.com'
      click_button 'COMMENT'

      expect(page).not_to have_selector '.has-error'
      expect(page).to have_selector('li[id^="comment-"]', count: comment_count + 1)
    end
  end

  context 'with INvalid comment' do
    scenario 'creating comment' do
      visit "/blog/posts/#{pst.slug}"

      click_link 'SHOW COMMENTS'

      expect(page).to have_text 'Comments'
      expect(page).to have_selector('li[id^="comment-"]', count: comment_count)

      click_link 'ADD A COMMENT'

      expect(page).to have_text 'New comment'

      expect(page).to have_selector('li[id^="comment-"]', count: comment_count)
      fill_in 'Text', with: 'Great post!'
      fill_in 'Avatar url', with: 'http://example.com/image.jpg'
      fill_in 'Profile link', with: 'https://github.com'
      click_button 'COMMENT'

      expect(page).to have_selector '.has-error'
      expect(page).to have_selector('li[id^="comment-"]', count: comment_count)
    end
  end
end

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  before { helper.extend(Haml::Helpers) }
  before { helper.extend(ActionView::Helpers) }
  before { helper.init_haml_helpers }
  let(:root_path) { '/' }

  describe '#admin?' do
    context 'when admin signed in' do
      xit 'returns true'
    end
    context 'when admin is not signed in' do
      xit 'returns false'
    end
  end

  describe '#nav_link' do
    it 'renders li' do
      expect(helper.nav_link('root', root_path)).to match /<li.*/
    end
    context 'when on the page' do
      before { allow(helper).to receive(:current_page?).and_return(true) }
      it 'has class active' do
        expect(helper.nav_link('root', root_path)).to match /<li[^>]+class=.active..*/
      end
    end
    context 'when on the other page' do
      before { allow(helper).to receive(:current_page?).and_return(false) }
      it 'has no class active' do
        expect(helper.nav_link('root', root_path)).not_to match /<class=.active./
      end
    end
  end
end


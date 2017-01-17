# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Draw deletion' do
  before { log_in FactoryGirl.create(:admin) }
  let(:draw) { FactoryGirl.create(:draw) }

  it 'succeeds' do
    msg = "Draw #{draw.name} deleted."
    visit draw_path(draw)
    click_on 'Delete'
    expect(page).to have_content(msg)
  end
end
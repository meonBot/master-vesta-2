# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Draw start selection' do
  let(:draw) { FactoryGirl.create(:draw_in_lottery) }
  before do
    log_in FactoryGirl.create(:admin)
    draw.groups.each { |g| g.update(lottery_number: 1) }
  end

  it 'can be done' do
    visit draw_path(draw)
    click_on 'Start suite selection'
    expect(page).to have_css('.flash-success', text: 'Suite selection started')
  end
end
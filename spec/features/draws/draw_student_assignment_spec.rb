# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Draw student assignment' do
  let(:draw) { create(:draw) }

  before { log_in create(:admin) }
  describe 'bulk adding' do
    before { create_pair(:student, class_year: 2016) }
    it 'can be performed' do
      visit draw_path(draw)
      click_on 'Add or edit students'
      bulk_assign_students(2016)
      message = 'Students successfully updated'
      expect(page).to have_css('.flash-success', text: message)
    end

    def bulk_assign_students(year)
      visit edit_draw_students_path(draw)
      select year.to_s, from: 'draw_students_update_class_year'
      click_on 'Assign students'
    end
  end

  describe 'single user adding' do
    let!(:student) { create(:student, username: 'foo') }

    it 'can be performed' do
      visit edit_draw_students_path(draw, student)
      fill_in 'draw_student_assignment_form_username', with: 'foo'
      click_on 'Process'
      message = "#{student.full_name} successfully added"
      expect(page).to have_css('.flash-success', text: message)
    end
  end

  describe 'single user removing' do
    let(:student) { create(:student, username: 'foo') }

    before { draw.students << student }
    it 'can be performed' do
      visit edit_draw_students_path(draw, student)
      remove_user(username: 'foo')
      message = "#{student.full_name} successfully removed"
      expect(page).to have_css('.flash-success', text: message)
    end

    def remove_user(username:)
      fill_in 'draw_student_assignment_form_username', with: username
      select 'Remove'
      click_on 'Process'
    end
  end
end

# frozen_string_literal: true
#
# Controller class for 'special' (admin-created outside of draw) housing groups.
class DrawlessGroupsController < ApplicationController
  prepend_before_action :set_group, only: %i(show edit update destroy
                                             select_suite)
  before_action :set_form_data, only: %i(new edit)

  def show; end

  def new; end

  def create
    result = DrawlessGroupCreator.new(drawless_group_params).create!
    @group = result[:record]
    set_form_data unless result[:object]
    handle_action(path: new_group_path, **result)
  end

  def edit; end

  def update
    result = DrawlessGroupUpdater.update(group: @group,
                                         params: drawless_group_params)
    @group = result[:record]
    set_form_data unless result[:object]
    handle_action(action: 'edit', **result)
  end

  def destroy
    result = Destroyer.new(object: @group, name_method: :name).destroy
    handle_action(**result)
  end

  def select_suite
    result = SuiteSelector.select(group: @group, suite_id: params['suite'])
    handle_action(action: 'show', **result)
  end

  private

  def authorize!
    @group ? authorize(DrawlessGroup.new(@group)) : authorize(DrawlessGroup)
  end

  def drawless_group_params
    params.require(:group).permit(:size, :leader_id, :suite, member_ids: [],
                                                             remove_ids: [])
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def set_form_data
    @group ||= Group.new
    @students = UngroupedStudentsQuery.call
    @leader_students = @group.members.empty? ? @students : @group.members
    @suite_sizes = SuiteSizesQuery.call
  end
end

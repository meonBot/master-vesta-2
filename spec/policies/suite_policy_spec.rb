# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SuitePolicy do
  subject { described_class }
  let(:suite) { FactoryGirl.build_stubbed(:suite) }

  context 'student' do
    let(:user) { FactoryGirl.build_stubbed(:user, role: 'student') }
    permissions :show? do
      context 'non-medical suite' do
        before { allow(suite).to receive(:medical).and_return(false) }
        it { is_expected.to permit(user, suite) }
      end
      context 'medical suite' do
        before { allow(suite).to receive(:medical).and_return(true) }
        it { is_expected.not_to permit(user, suite) }
      end
    end
    permissions :new?, :create?, :view_draw? do
      it { is_expected.not_to permit(user, Suite) }
    end
    permissions :destroy?, :edit?, :update?, :merge?, :perform_merge?,
                :build_split?, :split?, :perform_split?, :medical? do
      it { is_expected.not_to permit(user, suite) }
    end
  end

  context 'housing rep' do
    let(:user) { FactoryGirl.build_stubbed(:user, role: 'rep') }
    permissions :show? do
      context 'non-medical suite' do
        before { allow(suite).to receive(:medical).and_return(false) }
        it { is_expected.to permit(user, suite) }
      end
      context 'medical suite' do
        before { allow(suite).to receive(:medical).and_return(true) }
        it { is_expected.not_to permit(user, suite) }
      end
    end
    permissions :new?, :create?, :view_draw? do
      it { is_expected.not_to permit(user, Suite) }
    end
    permissions :merge?, :perform_merge?, :build_split?, :split?,
                :perform_split?, :destroy?, :medical? do
      it { is_expected.not_to permit(user, suite) }
    end
  end

  context 'admin' do
    let(:user) { FactoryGirl.build_stubbed(:user, role: 'admin') }
    permissions :show?, :edit?, :update?, :destroy?, :merge?, :perform_merge?,
                :medical? do
      it { is_expected.to permit(user, suite) }
    end
    permissions :new?, :create?, :view_draw? do
      it { is_expected.to permit(user, Suite) }
    end
    permissions :build_split?, :split?, :perform_split? do
      context 'suite has fewer than two rooms' do
        before do
          allow(suite).to receive(:rooms).and_return([instance_spy('Room')])
        end
        it { is_expected.not_to permit(user, suite) }
      end
      context 'suite has at least two rooms' do
        before do
          allow(suite).to receive(:rooms)
            .and_return([instance_spy('Room'), instance_spy('Room')])
        end
        it { is_expected.to permit(user, suite) }
      end
    end
  end
end

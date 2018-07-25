# frozen_string_literal: true

FactoryBot.define do
  factory :building do
    sequence(:name) { |n| "Building#{n}" }
  end
end

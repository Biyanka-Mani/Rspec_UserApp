FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@gmail.com" }
    first_name { "Juan" }
    last_name { "Grey" }
    password { "testtest" }
    is_admin { false }  # Default to false

    trait :admin do
      is_admin { true }
    end
  end
  end
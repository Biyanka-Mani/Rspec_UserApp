FactoryBot.define do
  factory :category do
    sequence(:name_of_category) { |n| "Programming#{n}" }
  end
end

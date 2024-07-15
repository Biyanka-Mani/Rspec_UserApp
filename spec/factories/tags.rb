FactoryBot.define do
  factory :tag do
    sequence(:name_of_tag) { |n| "Techies#{n}" }
  end
end

FactoryBot.define do
  factory :article_category do
    association :article
    association :category
  end
end
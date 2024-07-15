FactoryBot.define do
      factory :article do
        name { "Article Title" }
        description { "Testing First Aticle description" }
        association :user
      end
  end
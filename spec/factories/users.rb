FactoryBot.define do
    factory :user do
     email {"test@gmail.com"}
      first_name { "Juan" }
      last_name { "Grey" }
      password { "testtest" }
    end
  end
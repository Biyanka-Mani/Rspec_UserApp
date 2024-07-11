require 'rails_helper'

RSpec.describe ArticleCategory, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "testing associations" do
    it "belongs to a Article" do
      expect { FactoryBot.build(:article_category).article }.to_not raise_error
    end
    it "belongs to a Category" do
      expect { FactoryBot.build(:article_category).category }.to_not raise_error
    end
  end
end

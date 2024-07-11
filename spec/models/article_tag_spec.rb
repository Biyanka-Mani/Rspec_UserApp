require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "testing associations" do
    it "belongs to a Article" do
      expect { FactoryBot.build(:article_tag).article }.to_not raise_error
    end
    it "belongs to a Tag" do
      expect { FactoryBot.build(:article_tag).tag }.to_not raise_error
    end
  end
end


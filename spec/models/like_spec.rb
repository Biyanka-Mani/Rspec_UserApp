require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:article) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user)
      article = create(:article)
      like = Like.new(user: user, article: article)
      expect(like).to be_valid
    end

    it 'is not valid without a user' do
      article = create(:article)
      like = Like.new(user: nil, article: article)
      expect(like).to_not be_valid
    end

    it 'is not valid without an article' do
      user = create(:user)
      like = Like.new(user: user, article: nil)
      expect(like).to_not be_valid
    end

    it 'is not valid with a duplicate user and article' do
      user = create(:user)
      article = create(:article)
      Like.create(user: user, article: article)
      like = Like.new(user: user, article: article)
      expect(like).to_not be_valid
    end
  end
end

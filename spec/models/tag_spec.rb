require 'rails_helper'

RSpec.describe Tag, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @tag = FactoryBot.create(:tag)
  end
  it "is valid with valid attributes" do
    expect(@tag).to be_valid
  end

  it "is not valid without a name" do
    @tag.name_of_tag = nil
    expect(@tag).to_not be_valid
  end

  it "is not valid with a name that is too short" do
    @tag.name_of_tag= "A"
    expect(@tag).to_not be_valid
  end

  it "is not valid with a name that is too long" do
    @tag.name_of_tag = "A" * 160
    expect(@tag).to_not be_valid
  end

  it "is not valid with a duplicate name" do
    @tag = create(:tag, name_of_tag: "Sample")
    duplicate_tag = Tag.new(name_of_tag: "Sample")
    expect(duplicate_tag).to_not be_valid
  end

  describe 'associations' do 
    it { is_expected.to have_many(:article_tags) }
    it { is_expected.to have_many(:articles).through(:article_tags) }
  end
end

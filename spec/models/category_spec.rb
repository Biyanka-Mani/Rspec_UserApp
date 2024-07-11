require 'rails_helper'

RSpec.describe Category, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before do
    @category = Category.new(name_of_category: "Sample")
  end

  it "is valid with valid attributes" do
    expect(@category).to be_valid
  end

  it "is not valid without a name" do
    @category.name_of_category = nil
    expect(@category).to_not be_valid
  end

  it "is not valid with a name that is too short" do
    @category.name_of_category = "A"
    expect(@category).to_not be_valid
  end

  it "is not valid with a name that is too long" do
    @category.name_of_category = "A" * 16
    expect(@category).to_not be_valid
  end

  it "is not valid with a duplicate name" do
    @category.save
    duplicate_category = Category.new(name_of_category: "Sample")
    expect(duplicate_category).to_not be_valid
  end


  describe 'associations' do 
    it { is_expected.to have_many(:article_categories) }
     it { is_expected.to have_many(:articles).through(:article_categories) }
  
  end
end




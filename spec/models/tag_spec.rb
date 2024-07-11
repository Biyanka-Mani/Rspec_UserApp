require 'rails_helper'

RSpec.describe Tag, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:tag){ FactoryBot.create(:tag)  }

  it 'has a name' do 
    expect(tag.name_of_tag).to eq('Techies')
    tag.name_of_tag='2024 Christmas'
    expect(tag.name_of_tag).to eq('2024 Christmas')
  end
  it "is invalid without a name" do
    tag = Tag.new(name_of_tag: nil)
    expect(tag).not_to be_valid
  end

  describe 'associations' do 
    it { is_expected.to have_many(:article_tags) }
    it { is_expected.to have_many(:articles).through(:article_tags) }
  end
end

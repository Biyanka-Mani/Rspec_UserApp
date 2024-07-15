require 'rails_helper'

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:article){ FactoryBot.create(:article)  }

  it 'has a name' do 
    expect(article.name).to eq('Article Title')
    article.name='NameoftheArticleIsChanged'
    expect(article.name).to eq('NameoftheArticleIsChanged')
  end

  it 'has a description' do 
    expect(article.description).to eq('Testing First Aticle description')
    article.description='DescriptionofArticleIsChanged'
    expect(article.description).to eq('DescriptionofArticleIsChanged')
  end

  it 'is not valid with name' do 
    article.name=nil
    expect(article).not_to be_valid
  end

  it 'is not valid with description' do 
    article.description=nil
    expect(article).not_to be_valid
  end

  it 'should have a length of minimum 2 characters and maximum of 50 characters with name'do 
    article.name='w'*1
    expect(article).not_to be_valid

    article.name='w'*160
    expect(article).not_to be_valid
  end
  
  it 'should have a length of minimum 15 characters and maximum of 500 characters with description'do 
    article.description='a'*10
    expect(article).not_to be_valid

    article.description='a'*1600
    expect(article).not_to be_valid
  end
  describe 'has an optional image assosication' do 
    #assosication
    it 'image respond or checks for assoisaction'do
      expect(article).to respond_to(:main_image)
    end
    #image attaching optional
    it 'image attaching is optional' do 
      expect(article.main_image).not_to be_attached
    end
    #image attached 
    it 'image attached 'do
      article.main_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'sample_image.png')),
                                filename: 'sample_image.png',content_type: 'image/png')
      expect(article.main_image).to be_attached
    end
  end



end

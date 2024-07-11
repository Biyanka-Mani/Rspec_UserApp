class Category < ApplicationRecord

    has_many :article_categories
    has_many :articles,through: :article_categories

   validates :name_of_category, presence: true,length:{minimum:2,maximum:15}
   validates_uniqueness_of :name_of_category
end

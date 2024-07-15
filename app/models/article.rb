class Article < ApplicationRecord
    enum :status, { draft: 0, published: 1, dropped: 2}
    belongs_to :user

    has_many :article_categories
    has_many :categories, through: :article_categories

    has_many :article_tags
    has_many :tags, through: :article_tags

    validates :name, presence: true,length:{minimum:2,maximum:50}
    validates :description, presence: true,length:{minimum:15,maximum:500}
    has_one_attached :main_image

    has_many :likes,dependent: :destroy  
end

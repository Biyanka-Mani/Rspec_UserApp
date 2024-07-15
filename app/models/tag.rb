class Tag < ApplicationRecord
    has_many :article_tags
    has_many :articles,through: :article_tags

    validates :name_of_tag, presence: true,length:{minimum:2,maximum:50}
    validates_uniqueness_of :name_of_tag
end

class AddNameAndDescriptionToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles,:name,:string
    add_column :articles,:description,:text
  end
end

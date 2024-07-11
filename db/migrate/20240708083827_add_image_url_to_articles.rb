class AddImageUrlToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles,:image_url,:string,null: true
  end
end

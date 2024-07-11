class CreateArticleTags < ActiveRecord::Migration[7.1]
  def change
    create_table :article_tags do |t|
      t.integer :article_id
      t.integer :tag_id
      t.timestamps
    end
  end
end

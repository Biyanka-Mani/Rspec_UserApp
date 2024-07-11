class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name_of_tag
      t.timestamps
    end
  end
end

class CreateCharactersGroups < ActiveRecord::Migration
  def change
    create_table :characters_groups do |t|
      t.string :name
      t.text :description
      t.integer :age_group
      t.timestamps null: false
    end
  end
end

class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :avatar_id
      t.integer :duration
      t.integer :characters_group_id
      t.integer :age_group
      t.timestamps null: false
    end
  end
end

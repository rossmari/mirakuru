class CreateActorsCharacters < ActiveRecord::Migration
  def change
    create_table :actors_characters do |t|
      t.integer :actor_id
      t.integer :character_id
      t.timestamps null: false
    end
  end
end

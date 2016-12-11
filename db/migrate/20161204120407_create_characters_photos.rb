class CreateCharactersPhotos < ActiveRecord::Migration
  def change
    create_table :characters_photos do |t|
      t.integer :photo_id
      t.integer :character_id
      t.timestamps null: false
    end
  end
end

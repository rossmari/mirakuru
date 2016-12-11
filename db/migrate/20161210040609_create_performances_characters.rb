class CreatePerformancesCharacters < ActiveRecord::Migration
  def change
    create_table :performances_characters do |t|
      t.integer :character_id
      t.integer :performance_id
      t.timestamps null: false
    end
  end
end

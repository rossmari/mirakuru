class CreatePricePositions < ActiveRecord::Migration
  def change
    create_table :price_positions do |t|
      t.integer :minutes
      t.integer :animators_count
      t.timestamps null: false
    end
  end
end

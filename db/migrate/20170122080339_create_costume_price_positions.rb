class CreateCostumePricePositions < ActiveRecord::Migration
  def change
    create_table :costume_price_positions do |t|
      t.integer :minutes
      t.integer :costume_count
      t.float :partner, default: 0
      t.float :open, default: 0
      t.float :exclusive, default: 0
      t.timestamps null: false
    end
  end
end

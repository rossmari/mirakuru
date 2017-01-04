class CreateOrdersCharacters < ActiveRecord::Migration
  def change
    create_table :orders_characters do |t|
      t.integer :order_id
      t.integer :character_id
      t.timestamps null: false
    end
  end
end

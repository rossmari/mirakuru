class CreateCustomersStages < ActiveRecord::Migration
  def change
    create_table :customers_stages do |t|
      t.integer :customer_id
      t.integer :stage_id
      t.timestamps null: false
    end
  end
end

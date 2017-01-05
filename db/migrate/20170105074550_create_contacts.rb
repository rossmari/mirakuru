class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :value
      t.integer :customer_id
      t.string :notice
      t.timestamps null: false
    end
  end
end

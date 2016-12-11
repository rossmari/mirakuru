class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :customer_type
      t.string :name
      t.string :company_name
      t.string :contact
      t.string :notice
      t.float :discount
      t.string :partner_link
      t.string :customer_name

      t.timestamps null: false
    end
  end
end

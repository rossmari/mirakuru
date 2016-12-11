class AddPayedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payed, :boolean, default: false, null: false
  end
end

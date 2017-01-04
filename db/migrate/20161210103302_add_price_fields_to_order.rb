class AddPriceFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :partner_money, :integer
    add_column :orders, :animator_money, :integer
    add_column :orders, :overheads, :integer
  end
end

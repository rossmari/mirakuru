class ChangeOrderAddress < ActiveRecord::Migration
  def change
    remove_column :orders, :address
    add_column :orders, :street, :string
    add_column :orders, :house, :string
  end
end

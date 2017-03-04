class RemoveCustomerNameFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :customer_name
  end
end

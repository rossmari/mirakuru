class AddExclusiveToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :exclusive, :boolean, default: false, null: false
  end
end

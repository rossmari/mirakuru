class UpdateCustomerDiscountType < ActiveRecord::Migration
  def change
    change_column :customers, :discount, :float, default: 0.0, null: false
  end
end

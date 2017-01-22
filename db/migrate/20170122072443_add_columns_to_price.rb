class AddColumnsToPrice < ActiveRecord::Migration
  def change
    add_column :price_positions, :partner_price, :float, default: 0
    add_column :price_positions, :open_price, :float, default: 0
    add_column :price_positions, :exclusive_price, :float, default: 0

    add_column :price_positions, :partner_salary, :float, default: 0
    add_column :price_positions, :open_salary, :float, default: 0
    add_column :price_positions, :exclusive_salary, :float, default: 0
  end
end

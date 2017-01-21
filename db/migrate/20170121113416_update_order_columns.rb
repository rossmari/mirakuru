class UpdateOrderColumns < ActiveRecord::Migration
  def change
    remove_column :orders, :character_id
    remove_column :orders, :performance_id
    remove_column :orders, :price
    remove_column :orders, :guests_count

    remove_column :orders, :payed
    remove_column :orders, :animator_money
    rename_column :orders, :overheads, :additional_expense
    change_column :orders, :additional_expense, :float
    remove_column :orders, :actor_notice
    remove_column :orders, :contact_name
    remove_column :orders, :contact_phone
    remove_column :orders, :dopnik
    add_column :orders, :order_calculations_notice, :string
    add_column :orders, :exclude_additional_expense, :boolean, default: false, null: false
    add_column :orders, :exclude_outcome, :boolean, default: false, null: false
    change_column :orders, :partner_money, :float
  end
end

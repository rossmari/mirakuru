class UpdateOrder < ActiveRecord::Migration
  def change
    add_column :orders, :customer_id, :integer
    add_column :orders, :character_id, :integer
    add_column :orders, :performance_id, :integer
    add_column :orders, :stage_id, :integer
    add_column :orders, :address, :string
    add_column :orders, :price, :float
    add_column :orders, :status, :integer
    add_column :orders, :child, :string
    add_column :orders, :child_age, :integer
    add_column :orders, :guests_count, :integer
    add_column :orders, :guests_age_from, :integer
    add_column :orders, :guests_age_to, :integer
    add_column :orders, :notice, :text
  end
end

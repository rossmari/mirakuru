class AddContactIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :contact_id, :integer
  end
end

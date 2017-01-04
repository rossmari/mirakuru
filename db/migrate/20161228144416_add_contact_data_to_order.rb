class AddContactDataToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :contact_name, :string
    add_column :orders, :contact_phone, :string
  end
end

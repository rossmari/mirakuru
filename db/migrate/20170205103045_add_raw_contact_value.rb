class AddRawContactValue < ActiveRecord::Migration
  def change
    add_column :contacts, :raw_value, :string
  end
end

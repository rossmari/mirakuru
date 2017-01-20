class ChangeChildFields < ActiveRecord::Migration
  def change
    rename_column :orders, :child, :child_name
    remove_column :orders, :child_age
    add_column :orders, :child_birthday, :date
  end
end

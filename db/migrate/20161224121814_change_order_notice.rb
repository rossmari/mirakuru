class ChangeOrderNotice < ActiveRecord::Migration
  def change
    rename_column :orders, :notice, :child_notice
    add_column :orders, :guests_notice, :string
  end
end

class AddMoreNoticesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :order_notice, :text
    add_column :orders, :actor_notice, :text
  end
end

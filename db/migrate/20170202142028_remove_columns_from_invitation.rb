class RemoveColumnsFromInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :character_id
    remove_column :invitations, :order_id
    remove_column :invitations, :start
    remove_column :invitations, :stop
    remove_column :invitations, :partner_payed
    remove_column :invitations, :price
    remove_column :invitations, :animator_money
    remove_column :invitations, :overheads
    remove_column :invitations, :order_notice
    remove_column :invitations, :owner_class
    remove_column :invitations, :owner_id
    remove_column :invitations, :actor_notice
  end
end

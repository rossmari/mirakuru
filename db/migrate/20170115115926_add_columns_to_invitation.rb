class AddColumnsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :partner_payed, :boolean, default: false, null: false
    add_column :invitations, :price, :integer
    add_column :invitations, :animator_money, :integer
    add_column :invitations, :overheads, :integer
    add_column :invitations, :order_notice, :text
  end
end


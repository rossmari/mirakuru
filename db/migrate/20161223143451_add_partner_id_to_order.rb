class AddPartnerIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :partner_id, :integer
  end
end

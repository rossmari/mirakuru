class AddPartnerPayedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :partner_payed, :boolean
  end
end

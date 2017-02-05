class AddAnimatorPayedToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :animator_payed, :boolean, default: false, null: false
  end
end

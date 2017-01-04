class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :character_id
      t.integer :actor_id
      t.integer :order_id
      t.integer :status, null: false, default: 0
      t.datetime :invitation_date
      t.timestamps null: false
    end
  end
end

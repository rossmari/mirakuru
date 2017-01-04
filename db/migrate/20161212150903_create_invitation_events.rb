class CreateInvitationEvents < ActiveRecord::Migration
  def change
    create_table :invitation_events do |t|
      t.integer :invitation_id
      t.integer :author_id
      t.integer :event_type
      t.timestamps null: false
    end
  end
end

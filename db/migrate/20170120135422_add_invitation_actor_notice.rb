class AddInvitationActorNotice < ActiveRecord::Migration
  def change
    add_column :invitations, :actor_notice, :text
  end
end

class RemoveInvitationDateFromInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :invitation_date
  end
end

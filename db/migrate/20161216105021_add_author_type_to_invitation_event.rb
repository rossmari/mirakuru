class AddAuthorTypeToInvitationEvent < ActiveRecord::Migration
  def change
    add_column :invitation_events, :author_type, :string
  end
end

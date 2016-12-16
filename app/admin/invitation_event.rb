ActiveAdmin.register InvitationEvent do

  index do
    column :id
    column :author
    column :invitation
    column :event_type do |record|
      t("admin.invitation_event.event_types.#{record.event_type}")
    end
    column :updated_at
  end

end

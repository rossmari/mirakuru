class InvitationEvent < ActiveRecord::Base

  belongs_to :invitation
  belongs_to :author, polymorphic: true

  validates :invitation_id, :event_type, presence: true
  enum event_type: [:actor_removed, :actor_assigned, :status_changed]

  class << self

    InvitationEvent.event_types.each do |event_name, value|
      define_method "#{event_name}!" do |invitation, author|
        create_invitation(invitation, author, value)
      end
    end

    def create_invitation(invitation, author, type)
      InvitationEvent.create(
        {
          invitation: invitation,
          event_type: type,
          author: author
        }
      )
    end

  end
end

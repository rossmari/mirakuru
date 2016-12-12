class InvitationEvent < ActiveRecord::Base

  belongs_to :invitation

  # actor was changed
  # actor can be set, or removed
  # by himself or by admin

  # status was changed
  # by admin
  # by system (time)

  # invitation was deleted
  # by admin

  enum event_type: [:reject]

end

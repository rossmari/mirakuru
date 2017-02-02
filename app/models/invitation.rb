class Invitation < ActiveRecord::Base

  belongs_to :position
  belongs_to :actor
  has_many :invitation_events

  enum status: [:empty, :sent, :received, :read, :accepted, :denied, :set_by_admin, :removed_by_admin, :closed]

  state_machine :status, initial: :empty do

    event :sent_invitation do
      transition [:empty, :denied] => :sent
    end

    event :set_actor do
      transition all - [:accepted, :closed] => :set_by_admin
    end

    event :close_invitation do
      transition all => :closed
    end

    event :actor_refused do
      transition all => :empty
    end

    after_transition on: :actor_refused, do: :actor_refused_event

  end

  # ===========================================
  # On transition methods
  def actor_refused_event
    # actor removed himself
    # TODO : remove actor ID from invitation
    # TODO : remove actor ID validation ???
    InvitationEvent.actor_removed!(self, actor)
  end

  # ===========================================

end

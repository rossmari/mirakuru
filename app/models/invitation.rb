class Invitation < ActiveRecord::Base

  belongs_to :position
  belongs_to :actor
  has_many :invitation_events

  # statuses separated by groups
  enum status: [
    # initial status
    :empty,
    # when you sent invitation to actor
    :sent,
    # when he accept it , or refused from it
    :accepted, :refused,
    # when he first accept it, then cancel
    :canceled,
    # when admin assign actor without sent invitation
    # by himself
    :assigned,
    # when admin decline actor accept
    :declined,
    # when we close invitation, its invisible, not active
    :closed
  ]

  state_machine :status, initial: :empty do

    # sent invitation to actor
    event :sent_invitation do
      transition [:empty] => :sent
    end

    # sent again action
    # just a stub for better reading
    event :sent_again do
      transition [:sent] => :sent
    end

    # admin approve actor on role by himself, no matter if
    # actor receive this invitation or not
    event :assign do
      transition [:empty, :sent, :canceled] => :assigned
    end

    # actor accept invitation that we send to him
    event :accept do
      transition [:empty, :sent] => :accepted
    end

    # actor refused from invitation
    # actor can receive invitation and refuse, or find this free invitation and refuse
    event :refuse do
      transition [:empty, :sent] => :refused
    end

    # actor first time accept invitation, then cancel
    event :cancel do
      transition [:accepted] => :canceled
    end

    event :close do
      transition all => :closed
    end

    after_transition on: :actor_refused, do: :actor_refused_event
    after_transition on: [:sent_invitation, :sent_again], do: :sent_invitation_to_actor
    after_transition on: [:accept, :assign], do: :close_other_invitations
  end

  def admin_available?(event)
    %i(sent_invitation sent_again assign close).include?(event)
  end

  def admin_events
    self.status_events.select{|event| admin_available?(event.to_sym)}
  end

  # ===========================================
  def sent_invitation_to_actor
    response = Telegram::AdminSender::Invitation.new(self).create_response
    Telegram::Callbacks::Processor.send_responses(response, self.actor.telegram_key)
  end

  def close_other_invitations
    invitations = Invitation.where(position_id: position_id).where.not(id: id)
    invitations.each{|i| i.fire_events!(:close)}
  end
  # ===========================================


end

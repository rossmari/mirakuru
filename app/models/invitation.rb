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
      transition [:assigned, :accepted] => :canceled
    end

    event :close do
      transition all - :closed => :closed
    end

    event :open do
      transition :closed => :empty, if: ->(invitation){ invitation.can_open? }
    end

    after_transition on: :actor_refused, do: :actor_refused_event
    after_transition on: [:sent_invitation, :sent_again], do: :sent_invitation_to_actor
    after_transition on: [:accept, :assign], do: [:close_position, :close_actor_invitations]
    after_transition on: [:assign], do: :sent_assign_notice_to_actor
  end

  def admin_available?(event)
    %i(sent_invitation sent_again assign close open).include?(event)
  end

  def admin_events
    self.status_events.select{|event| admin_available?(event.to_sym)}
  end

  # ===========================================
  def sent_invitation_to_actor
    response = Telegram::AdminSender::Invitation.new(self).create_response
    Telegram::Callbacks::Processor.send_responses(response, self.actor.telegram_key)
  end

  def close_actor_invitations
    invitations = actor_invitations.reject{ |i| i.id == id }
    invitations.each do |record|
      if record.status != 'closed'
        record.fire_events!(:close)
      end
    end
  end

  def close_position
    invitations = position_invitations.reject{|i| i.id == id}
    invitations.each do |i|
      i.fire_events!(:close) if i.status != 'closed'
    end
  end

  def sent_assign_notice_to_actor
    response = Telegram::AdminSender::Assign.new(self).create_response
    Telegram::Callbacks::Processor.send_responses(response, self.actor.telegram_key)
  end

  def can_open?
    actor_statuses =  actor_invitations.reject{|i| i.id == id}.map(&:status)
    position_statuses = position_invitations.map(&:status)
    # if invitation position is not occupied yet && if actor is not occupied yet
    (position_statuses & %w(accepted assigned)).empty? && (actor_statuses & %w(accepted assigned)).empty?
  end
  # ===========================================

  def order
    self.position.order
  end

  def order_invitations
    order.positions.map(&:invitations).flatten
  end

  def position_invitations
    self.position.invitations
  end

  def actor_invitations
    order_invitations.select{ |i| i.actor_id == actor_id}
  end

end

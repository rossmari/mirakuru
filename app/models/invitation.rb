class Invitation < ActiveRecord::Base

  belongs_to :order
  belongs_to :actor
  belongs_to :character

  has_many :invitation_events

  enum status: [:sent, :received, :read, :accepted, :denied, :set_by_admin, :removed_by_admin]

  validates :character, :start, :stop, :animator_money, :price,
            :overheads, :actor_id, presence: true

  before_save :check_changed_attributes, :prepare_owner_class

  attr_accessor :author

  def owner
    owner_class.constantize.find(owner_id)
  end

  private

  def check_changed_attributes
    if actor_id_changed?
      if actor_id_was.blank? && actor_id
        InvitationEvent.actor_assigned!(self, author)
      end

      if actor_id_was && actor_id.blank?
        InvitationEvent.actor_removed!(self, author)
      end
    end

    if status_changed?
      InvitationEvent.status_changed!(self, author)
    end

  end

  def prepare_owner_class
    self.owner_class = owner_class.capitalize
  end

end

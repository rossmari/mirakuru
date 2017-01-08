class Invitation < ActiveRecord::Base

  belongs_to :order
  belongs_to :actor
  belongs_to :character

  has_many :invitation_events

  enum status: [:empty, :accepted]

  validates :character, presence: true #:order,

  before_save :check_changed_attributes

  attr_accessor :author

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

end

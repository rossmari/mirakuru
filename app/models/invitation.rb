class Invitation < ActiveRecord::Base

  belongs_to :order
  belongs_to :actor
  belongs_to :character

  has_many :invitation_events

  enum status: [:empty, :accepted]

  validates :order, :character, presence: true

end

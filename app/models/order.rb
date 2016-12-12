class Order < ActiveRecord::Base

  belongs_to :customer
  belongs_to :performance
  belongs_to :stage

  has_many :orders_characters
  accepts_nested_attributes_for :orders_characters, allow_destroy: true

  has_many :characters, through: :orders_characters

  has_many :invitations

  enum status: [:active, :success, :rejected_customer, :rejected_actor]

  validate :place_presence
  validate :performance_presence
  validates :status, :customer, presence: true

  after_commit :generate_invitations

  private

  def place_presence
    if address.blank? && stage_id.blank?
      errors.add(:address, :blank)
      errors.add(:stage_id, :blank)
    end
  end

  def performance_presence
    if performance_id.blank? && character_id.blank?
      errors.add(:performance_id, :blank)
      errors.add(:character_id, :blank)
    end
  end

  def generate_invitations
    characters = []
    characters += self.characters.to_a
    if performance
      characters += performance.characters.to_a
    end
    characters.compact!

    characters.each do |character|
      Invitation.find_or_create_by(
        {
          character_id: character.id,
          order_id: id,
          status: Invitation.statuses[:empty],
        })
    end

  end

end

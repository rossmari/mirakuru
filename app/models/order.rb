class Order < ActiveRecord::Base

  belongs_to :customer
  # TODO : many different characters
  belongs_to :character
  belongs_to :performance
  belongs_to :stage

  enum status: [:active, :success, :rejected_customer, :rejected_actor]

  validate :place_presence
  validate :performance_presence
  validates :status, :customer, presence: true

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

end

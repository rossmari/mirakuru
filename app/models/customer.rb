require 'securerandom'

class Customer < ActiveRecord::Base

  enum customer_type: [:physical, :entity, :partner]

  # validate :customer_name_presence
  before_save :generate_partner_link
  has_many :contacts

  private

  def customer_name_presence
    if partner?
      if customer_name.blank?
        errors.add(:customer_name, :blank)
      end
    end
  end

  def generate_partner_link
    if partner?
      string_part = SecureRandom.urlsafe_base64(8)
      self.partner_link = "#{customer_name}-#{string_part}-#{id}"
    end
  end

end

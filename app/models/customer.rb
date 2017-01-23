require 'securerandom'

class Customer < ActiveRecord::Base

  enum customer_type: [:physical, :entity, :partner]

  validates :name, :customer_type, presence: true
  before_save :generate_partner_link
  has_many :contacts
  has_many :customers_stages
  has_many :stages, through: :customers_stages
  accepts_nested_attributes_for :customers_stages, allow_destroy: true

  private

  def generate_partner_link
    if partner?
      string_part = SecureRandom.urlsafe_base64(8)
      self.partner_link = "#{customer_name}-#{string_part}-#{id}"
    end
  end

end

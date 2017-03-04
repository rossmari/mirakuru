require 'securerandom'

class Customer < ActiveRecord::Base

  enum customer_type: [:physical, :entity, :partner]

  validates :name, :customer_type, presence: true
  validates :partner_link, uniqueness: true
  before_save :generate_partner_link
  has_many :contacts
  has_many :customers_stages
  # todo : remove ?
  has_many :stages, through: :customers_stages
  accepts_nested_attributes_for :customers_stages, allow_destroy: true

  private

  def generate_partner_link
    if partner? && partner_link.blank?
      self.partner_link = SecureRandom.uuid.first(8)
    end
  end

end

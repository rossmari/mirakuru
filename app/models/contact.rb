class Contact < ActiveRecord::Base

  belongs_to :customer
  has_many :orders

  validates :value, :notice, presence: true
  before_save :create_raw_value

  def description
    "#{value} / #{notice}"
  end

  private

  def self.clear_phone(phone)
    # make raw phone
    # todo : make this safe for html?
    phone.gsub(/\+|\(|\)|\s{1}/, '')
  end

  def create_raw_value
    self.raw_value = Contact.clear_phone(value)
  end

end

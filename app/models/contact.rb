class Contact < ActiveRecord::Base

  belongs_to :customer
  has_many :orders

  validates :value, :notice, presence: true

  def description
    "#{value} / #{notice}"
  end

end

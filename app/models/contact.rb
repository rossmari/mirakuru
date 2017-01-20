class Contact < ActiveRecord::Base

  belongs_to :customer
  has_many :orders

  def description
    "#{value} / #{notice}"
  end

end

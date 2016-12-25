class Stage < ActiveRecord::Base

  validates :name, :street, :house, presence: true
  has_many :partners

end

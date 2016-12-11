class Stage < ActiveRecord::Base

  validates :address, presence: true
  has_many :partners

end

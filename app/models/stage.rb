class Stage < ActiveRecord::Base

  validates :address, :name, presence: true
  has_many :partners

end

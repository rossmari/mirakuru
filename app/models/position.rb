class Position < ActiveRecord::Base

  belongs_to :order
  belongs_to :character
  has_many :invitations

  validates :start, :stop, :price, :animator_money, :overheads, presence: true

  def owner
    owner_class.constantize.find(owner_id)
  end

end

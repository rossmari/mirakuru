class Position < ActiveRecord::Base

  belongs_to :order
  belongs_to :character

  has_many :invitations

  def owner
    owner_class.constantize.find(owner_id)
  end

end

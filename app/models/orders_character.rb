class OrdersCharacter < ActiveRecord::Base

  belongs_to :order
  belongs_to :character

end

class PerformancesCharacter < ActiveRecord::Base

  belongs_to :performance
  belongs_to :character

end

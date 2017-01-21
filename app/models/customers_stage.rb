class CustomersStage < ActiveRecord::Base

  belongs_to :customer
  belongs_to :stage

end

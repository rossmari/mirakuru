class Partner < ActiveRecord::Base

  belongs_to :stage

  validates :name, :phone, :contacts, :stage_id, presence: true

end

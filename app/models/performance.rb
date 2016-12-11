class Performance < ActiveRecord::Base

  has_many :performances_characters
  has_many :characters, through: :performances_characters
  accepts_nested_attributes_for :performances_characters

  has_one :avatar, as: :cover, class_name: 'Avatar'
  accepts_nested_attributes_for :avatar

  has_many :photo, as: :cover, class_name: 'Photo'
  accepts_nested_attributes_for :photo, allow_destroy: true

end

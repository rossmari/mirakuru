class Actor < ActiveRecord::Base

  has_one :avatar, as: :cover, class_name: 'Avatar'
  accepts_nested_attributes_for :avatar

  validates :name, :age, :phone, presence: true

  has_many :actors_characters
  accepts_nested_attributes_for :actors_characters, allow_destroy: true

  has_many :characters, through: :actors_characters

end

class Character < ActiveRecord::Base

  has_one :avatar, as: :cover, class_name: 'Avatar'
  accepts_nested_attributes_for :avatar

  has_many :photo, as: :cover, class_name: 'Photo'
  accepts_nested_attributes_for :photo, allow_destroy: true

  has_many :actors_characters
  has_many :actors, through: :actors_characters

  belongs_to :characters_group

  has_many :performances_characters
  has_many :performances, through: :performances_characters

  has_many :invitations
  has_many :positions

  enum duration: {'15 minutes' => 1, '30 minutes' => 2, '45 minutes' => 3, '60 minutes (15 minutes +)' => 4}

  validates :name, :duration, presence: true
  validates :avatar, presence: true

end

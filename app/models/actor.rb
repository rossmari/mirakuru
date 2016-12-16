class Actor < ActiveRecord::Base

  has_one :avatar, as: :cover, class_name: 'Avatar'
  accepts_nested_attributes_for :avatar

  validates :name, :age, :phone, presence: true

  has_many :actors_characters
  accepts_nested_attributes_for :actors_characters, allow_destroy: true

  has_many :characters, through: :actors_characters

  has_many :orders_characters
  has_many :orders, through: :orders_characters

  has_many :invitations

  has_many :invitation_events, as: :author

end

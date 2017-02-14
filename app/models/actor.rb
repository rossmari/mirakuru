class Actor < ActiveRecord::Base
  mount_uploader :avatar, PhotoUploader

  validates :name, :age, :phone, presence: true

  has_many :actors_characters
  has_many :characters, through: :actors_characters

  has_many :orders_characters
  has_many :orders, through: :orders_characters

  has_many :invitations
  has_many :invitation_events, as: :author

  scope :by_character, ->(character_id) { joins(:characters).where('characters.id = ?', character_id) }

end

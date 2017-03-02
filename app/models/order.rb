class Order < ActiveRecord::Base

  attr_accessor :is_new_order, :is_new_stage

  belongs_to :customer
  belongs_to :performance
  belongs_to :stage
  belongs_to :order_source

  has_many :orders_characters
  accepts_nested_attributes_for :orders_characters, allow_destroy: true

  has_many :characters, through: :orders_characters

  has_many :invitations, dependent: :destroy
  has_many :positions, dependent: :destroy

  enum source: [:partner, :site, :commercial]

  validates :child_name, :child_birthday, :performance_date, :performance_time,
            :guests_age_from, :guests_age_to, :additional_expense, presence: true

  belongs_to :contact

  after_commit :generate_invitations

  enum status: [:fresh, :assigned, :prepared, :done, :canceled_by_customer, :canceled_by_owner, :failed]

  private

  def generate_invitations
    characters = []
    characters += self.characters.to_a
    if performance
      characters += performance.characters.to_a
    end
    characters.compact!

    characters.each do |character|
      Invitation.find_or_create_by(
        {
          character_id: character.id,
          order_id: id,
          status: Invitation.statuses[:empty],
        })
    end
  end

end

class Stage < ActiveRecord::Base

  before_validation :generate_name
  validates :name, :street, :house, presence: true
  has_many :partners

  has_many :customers_stages
  has_many :customers, through: :customers_stages

  private

  def generate_name
    if name.blank?
      self.name = "#{street} / #{house} / #{apartment}"
    end
  end

end

class Stage < ActiveRecord::Base

  before_save :generate_name

  validates :district, :street, :house, :apartment, presence: true

  has_many :partners
  # TODO : why has many?
  has_many :customers_stages
  has_many :customers, through: :customers_stages
  belongs_to :district

  def address
    "#{street} / #{house} / #{apartment}"
  end

  private

  def generate_name
    if name.blank?
      self.name = address
    end
  end

end

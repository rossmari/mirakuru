class AddPhoneToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :phone, :string
  end
end

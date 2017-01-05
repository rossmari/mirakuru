class AddFieldsIntoStage < ActiveRecord::Migration
  def change
    add_column :stages, :district, :integer
    add_column :stages, :apartment, :string
  end
end

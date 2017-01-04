class UpdateStage < ActiveRecord::Migration
  def change
    remove_column :stages, :address
    add_column :stages, :street, :string
    add_column :stages, :house, :string
  end
end

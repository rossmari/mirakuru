class AddStageName < ActiveRecord::Migration
  def change
    add_column :stages, :name, :string
  end
end

class AddFixedParamsToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :fixed_start, :boolean, default: false, null: false
    add_column :positions, :fixed_stop, :boolean, default: false, null: false
  end
end


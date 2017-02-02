class RemoveCorrectorFromPosition < ActiveRecord::Migration
  def change
    remove_column :positions, :corrector
  end
end

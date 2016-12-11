class UpdateCharacter < ActiveRecord::Migration
  def change
    remove_column :characters, :avatar_id
  end
end

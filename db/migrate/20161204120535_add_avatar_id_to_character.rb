class AddAvatarIdToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :avatar_id, :integer
  end
end

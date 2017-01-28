class AddDescriptionToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :description, :text
  end
end

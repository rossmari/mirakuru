class UpdatePhoto < ActiveRecord::Migration
  def change
    rename_column :photos, :photable_id, :cover_id
    rename_column :photos, :photable_type, :cover_type
  end
end

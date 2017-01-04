class AddPhotableToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :photable_type, :string
    add_column :photos, :photable_id, :integer
  end
end

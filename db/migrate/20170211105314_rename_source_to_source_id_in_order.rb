class RenameSourceToSourceIdInOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :source, :order_source_id
  end
end

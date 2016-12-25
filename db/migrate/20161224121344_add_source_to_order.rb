class AddSourceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :source, :integer
  end
end

class AddPositionIdToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :position_id, :integer
  end
end

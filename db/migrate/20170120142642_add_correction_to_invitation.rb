class AddCorrectionToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :corrector, :integer, default: 0
  end
end

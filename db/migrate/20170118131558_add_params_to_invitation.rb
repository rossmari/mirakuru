class AddParamsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :owner_class, :string
    add_column :invitations, :owner_id, :integer
  end
end

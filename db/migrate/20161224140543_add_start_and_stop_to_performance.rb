class AddStartAndStopToPerformance < ActiveRecord::Migration
  def change
    add_column :invitations, :start, :datetime
    add_column :invitations, :stop, :datetime
  end
end

class AddPerformanceTimeColumn < ActiveRecord::Migration
  def change
    add_column :orders, :performance_time, :time
  end
end

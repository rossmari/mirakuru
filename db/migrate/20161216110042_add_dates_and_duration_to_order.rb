class AddDatesAndDurationToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :performance_date, :date
    add_column :orders, :performance_duration, :integer
    add_column :orders, :dopnik, :integer
  end
end

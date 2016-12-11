class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :name
      t.string :contacts
      t.string :telegram_key
      t.string :age
      t.string :phone
      t.string :avatar
      t.timestamps null: false
    end
  end
end

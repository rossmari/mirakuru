class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :contacts
      t.string :notice
      t.integer :stage_id
      t.timestamps null: false
    end
  end
end

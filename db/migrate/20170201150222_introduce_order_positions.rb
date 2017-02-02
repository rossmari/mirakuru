class IntroduceOrderPositions < ActiveRecord::Migration
  def change

    create_table :positions do |t|
      t.integer :character_id
      t.integer :order_id
      t.integer :status, default: 0
      t.datetime :start
      t.datetime :stop

      t.float :price, default: 0
      t.float :overheads, default: 0
      t.float :animator_money, default: 0
      t.boolean :payed, default: false, null: false

      t.timestamps null: false

      t.string :order_notice
      t.string :actor_notice
      t.string :owner_class
      t.integer :owner_id
      t.float :corrector, default: 0.0, null: false
    end

  end
end

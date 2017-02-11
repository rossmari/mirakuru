class CreateOrderSources < ActiveRecord::Migration
  def change
    create_table :order_sources do |t|
      t.string :value
      t.timestamps null: false
    end

    OrderSource.create(value: 'Партнер')
    OrderSource.create(value: 'Сайт')
    OrderSource.create(value: 'Реклама')
  end
end

ActiveAdmin.register Position do
  menu false

  filter :order_id, label: 'Order ID', as: :numeric, filters: ['eq']
  filter :start
  filter :stop
  filter :updated_at
  filter :payed, as: :check_boxes, collection: [['True', true],['False', false]]
  filter :animator_payed, as: :check_boxes, collection: [['True', true],['False', false]]

  index do
    id_column
    column :character
    column :order_id do |record|
      link_to(record.order_id, admin_order_path(record.order))
    end
    column :start
    column :stop
    column :price
    column :overheads
    column :animator_money
    column :payed
    column :animator_payed
    column :updated_at
    actions
  end

end

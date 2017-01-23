ActiveAdmin.register Contact do

  permit_params :customer_id, :value, :notice

  index do
    column :id
    column :value
    column :customer
    column :notice
    column :updated_at
    actions
  end

end

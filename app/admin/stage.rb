ActiveAdmin.register Stage do

  permit_params :address, :description, :name

  filter :address
  filter :description
  filter :name
  filter :updated_at

end
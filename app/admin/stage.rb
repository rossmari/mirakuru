ActiveAdmin.register Stage do

  permit_params :address, :description

  filter :address
  filter :description
  filter :updated_at

end
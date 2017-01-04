ActiveAdmin.register Stage do

  permit_params :street, :house, :name, :description

  filter :description
  filter :name
  filter :updated_at

  index do
    column :id
    column :name
    column :street
    column :house
    column :description
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :street
      f.input :house
      f.input :description, input_html: { rows: 10, style: 'width:50%'}
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :street
      row :house
      row :description
      row :updated_at
    end
  end

end
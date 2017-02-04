ActiveAdmin.register Stage do

  permit_params :street, :house, :name, :description, :apartment, :district_id

  filter :description
  filter :name
  filter :updated_at

  index do
    column :id
    column :name
    column :district
    column :street
    column :house
    column :apartment
    column 'Партнер' do |record|
      if record.customers.any?
        record.customers.map do |customer|
          link_to(customer.name, admin_customer_path(customer))
        end.join('<br>').html_safe
      else
        'Нет партнера'
      end
    end
    column :description
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name, hint: 'По умолчанию название будет сгенерировано из района, дома и квартиры'
      f.input :district,
              as: :select,
              collection: District.all,
              include_blank: false

      f.input :street
      f.input :house
      f.input :apartment
      f.input :description, input_html: { rows: 10, style: 'width:50%'}
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :district
      row :street
      row :house
      row :apartment
      row :description
      row :updated_at
    end
  end

end

ActiveAdmin.register Partner do

  permit_params :name, :contacts, :notice, :stage_id, :phone

  filter :stage,
         as: :select,
         collection: ->{Stage.all.map{|stage| [stage.name, stage.id]}}
  filter :name
  filter :contacts

  form do |f|
    f.inputs do
      f.input :name
      f.input :contacts
      f.input :phone
      f.input :notice
      f.input :stage, as: :select, collection: Stage.all.map{|stage| [stage.name, stage.id]},
        include_blank: false
    end
    f.actions
  end

  index do
    column :id
    column :name
    column :contacts
    column :phone
    column :updated_at
    column :stage_name do |record|
      if record.stage
        record.stage.name
      else
        'Площадка не указана'
      end
    end
    actions
  end

end

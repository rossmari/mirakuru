ActiveAdmin.register Partner do

  permit_params :name, :contacts, :notice, :stage_id

  filter :stage,
         as: :select,
         collection: Stage.all.map{|stage| [stage.address, stage.id]}
  filter :name
  filter :contacts

  form do |f|
    f.inputs do
      f.input :name
      f.input :contacts
      f.input :notice
      f.input :stage, as: :select, collection: Stage.all.map{|stage| [stage.address, stage.id]}
    end
    f.actions
  end


end

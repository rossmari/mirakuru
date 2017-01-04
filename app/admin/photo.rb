ActiveAdmin.register Photo do

  actions :show, :index

  filter :updated_at

  index do
    column :id
    column :file
    column :cover_type
    column :updated_at
    column :preview do |record|
      image_tag(record.file.url(:thumb))
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :photo do |record|
        image_tag record.file.url
      end
    end
  end

end
ActiveAdmin.register User do

  permit_params :email, :name, :password, :password_confirmation

  filter :email
  filter :name

  index do
    id_column
    column :email
    column :name
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :id
      row :email
      row :name
      row :sign_in_count
      row :updated_at
    end

    render partial: 'admin/common/events_table', locals: {events: record.invitation_events}
  end

end

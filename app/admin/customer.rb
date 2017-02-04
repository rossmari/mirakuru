ActiveAdmin.register Customer do

  permit_params :customer_type, :name, :company_name, :contact, :notice, :discount,
                :customer_name, customers_stages_attributes: [:stage_id, :id, :_destroy]

  filter :customer_type,
         as: :select,
         collection: ->{Customer.customer_types.map{|key, _value| [I18n.t("admin.customer.customer_types.#{key}"), _value]}}
  filter :name
  filter :company_name
  # filter :contact
  filter :updated_at

  index do
    id_column
    column :name
    column :customer_type do |record|
      t("admin.customer.customer_types.#{record.customer_type}")
    end
    column :company_name
    column 'Контакты' do |record|
      record.contacts.map do |contact|
        link_to(contact.description, admin_contact_path(contact))
      end.join('<br>').html_safe
    end
    # column :discount do |record|
    #   "#{record.discount} %"
    # end
    column :partner_link do |record|
      if record.partner?
        url = "#{admin_root_url}/#{record.partner_link}"
        link_to(url, url)
      else
        t('admin.customer.not_partner')
      end
    end
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :customer_type,
              as: :select,
              collection: Customer.customer_types.map{|key, value| [t("admin.customer.customer_types.#{key}"), key] },
              include_blank: false
      f.input :name
      f.input :company_name
      # f.input :contact
      f.input :notice
      f.input :discount
      f.input :customer_name
      f.has_many :customers_stages, new_record: true, allow_destroy: true do |c|
        c.input :stage_id, as: :select, label: 'Площадки заказчика', collection: Stage.all.map{|ch| [ch.name, ch.id]}
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :customer_type do |record|
        t("admin.customer.customer_types.#{record.customer_type}")
      end
      row :name
      row :company_name
      row 'Контакты' do |record|
        record.contacts.map do |contact|
          link_to(contact.description, admin_contact_path(contact))
        end.join('<br>').html_safe
      end
      row :notice
      row :discount do |record|
        "#{record.discount.to_f} %"
      end
      row 'Площадка' do |record|
        record.stages.map(&:name).join('<br>').html_safe
      end
      row :partner_link do |record|
        if record.partner?
          url = "#{admin_root_url}/#{record.partner_link}"
          link_to(url, url)
        else
          t('admin.customer.not_partner')
        end
      end
      row :updated_at
    end
  end

end

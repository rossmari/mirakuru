ActiveAdmin.register Order do

  permit_params :customer_id, :character_id, :stage_id, :address,
                :status, :price, :partner_money, :animator_money,
                :overheads, :payed, :child, :child_age, :guests_count,
                :guests_age_from, :guests_age_to, :notice,
                :performance_id

  filter :customer
  filter :stage, as: :select,
          collection: ->{Stage.all.map{|stage| [stage.address, stage.id]}}
  filter :performance
  filter :character
  filter :status
  filter :payed
  filter :price

  index do
    column :id
    column :customer
    column :status do |record|
      t("admin.order.statuses.#{record.status}")
    end
    column 'Выступление' do |record|
      description = []
      if record.character
        description << 'Персонажи:'
        description << record.character.name
      end
      if record.performance
        description << 'Выступление:'
        description << record.performance.name
      end
      description.join('<br>').html_safe
    end
    column 'Место' do |record|
      description = []
      if record.stage
        description << 'Площадка:'
        description << record.stage.description
        description << record.stage.address
      end
      if record.address.present?
        description << 'Адрес:'
        description << record.address
      end
      description.join('<br>').html_safe
    end
    column :price
    column :payed
    column 'Дата проведения мероприятия' do
      'Пока неизвестно'
    end
    column 'Ребенок' do |record|
      "#{record.child}<br>#{record.child_age} лет".html_safe
    end
    column 'Описание гостей' do |record|
      "#{record.guests_count} человек<br>#{record.guests_age_from}-#{record.guests_age_to} лет".html_safe
    end
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :address, input_html: {placeholder: 'Необходимо указать адрес или выбрать площадку'}
      f.input :customer, as: :select,
        collection: Customer.all.map{|customer| [customer.name, customer.id]},
        include_blank: false
      f.input :status, as: :select,
              collection: Order.statuses.map{|key, _value| [t("admin.order.statuses.#{key}"), key]},
              include_blank: false

      f.input :stage, as: :select,
              collection: Stage.all.map{|stage| [stage.address, stage.id]},
              include_blank: true,
              prompt: 'Площадка не выбрана'

      f.inputs 'Мероприятие - Выберите программу или персонажей' do
        f.input :character, as: :select,
                collection: Character.all.map{|character| [character.name, character.id]},
                include_blank: false
        f.input :performance,
                as: :select,
                collection: Performance.all.map{|p| [p.name, p.id]},
                include_blank: true,
                prompt: 'Программа не выбрана'
      end

      f.inputs 'Стоймость заказа' do
        f.input :price
        f.input :partner_money
        f.input :animator_money
        f.input :overheads
        f.input :payed
      end

      f.inputs 'Именинник' do
        f.input :child
        f.input :child_age
      end
      f.inputs 'Гости' do
        f.input :guests_count
        f.input :guests_age_from
        f.input :guests_age_to
      end
      f.input :notice, input_html: { rows: 10, style: 'width:50%'}
    end
    f.actions
  end


  show do
    attributes_table do
      row :customer
      row :payed
      row :status do |record|
        t("admin.order.statuses.#{record.status}")
      end
      row :character
      row :performance
      row :stage
      row :address
      row :price
      row :partner_money
      row :animator_money
      row :overheads
      row :child_age
      row :guests_count
      row :guests_age_from
      row :guests_age_to
      row :notice
      row :updated_at
    end
  end

end


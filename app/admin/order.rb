ActiveAdmin.register Order do

  permit_params :customer_id, :character_id, :stage_id, :address,
                :status, :price, :partner_money, :animator_money,
                :overheads, :payed, :child, :child_age, :guests_count,
                :guests_age_from, :guests_age_to, :notice, :partner_payed,
                :performance_date, :performance_duration, :dopnik,
                :partner_id, :street, :house, :child_notice, :contact_name, :contact_phone,
                :source, :guests_notice, :performance_time, :order_notice, :actor_notice,
                :performance_id, orders_characters_attributes: [:character_id, :id, :_destroy],
                contact: [:value, :notice]

  filter :customer
  filter :stage, as: :select,
          collection: ->{Stage.all.map{|stage| [stage.name, stage.id]}}
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
      if record.characters.any?
        description << 'Персонажи:'
        description << record.characters.map(&:name).join('<br>')
      end
      if record.performance
        description << 'Выступление:'
        description << record.performance.name
      end
      description.join('<br>').html_safe
    end
    column 'Место' do |record|
      "#{record.street}, #{record.house}"
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

  form partial: 'form'
    # f.inputs do
    #   f.input :address, input_html: {placeholder: 'Необходимо указать адрес или выбрать площадку'}
    #   f.input :customer, as: :select,
    #     collection: Customer.all.map{|customer| [customer.name, customer.id]},
    #     include_blank: false
    #   f.input :status,
    #           as: :select,
    #           collection: Order.statuses.map{|key, _value| [t("admin.order.statuses.#{key}"), key]},
    #           include_blank: false
    #
    #   f.input :stage,
    #           as: :select,
    #           collection: Stage.all.map{|stage| [stage.name, stage.id]},
    #           include_blank: 'Площадка не выбрана'
    #
    #   f.inputs 'Мероприятие - Выберите программу или персонажей' do
    #     f.has_many :orders_characters, new_record: true, allow_destroy: true do |c|
    #       c.input :character_id, as: :select, collection: Character.all.map{|ch| [ch.name, ch.id]},
    #         include_blank: false
    #     end
    #     f.input :performance,
    #             as: :select,
    #             collection: Performance.all.map{|p| [p.name, p.id]},
    #             include_blank: 'Программа не выбрана'
    #
    #     f.input :performance_date, as: :datetime_picker
    #     f.input :performance_duration
    #   end
    #
    #   f.inputs 'Стоймость заказа' do
    #     f.input :price
    #     f.input :partner_money
    #     f.input :partner_payed
    #     f.input :animator_money
    #     f.input :overheads
    #     f.input :dopnik
    #     f.input :payed
    #   end
    #
    #   f.inputs 'Именинник' do
    #     f.input :child
    #     f.input :child_age
    #   end
    #   f.inputs 'Гости' do
    #     f.input :guests_count
    #     f.input :guests_age_from
    #     f.input :guests_age_to
    #   end
    #   f.input :notice, input_html: { rows: 10, style: 'width:50%'}
    # end
    # f.actions
  # end

  show do
    attributes_table do
      row :customer
      row :payed
      row :status do |record|
        t("admin.order.statuses.#{record.status}")
      end
      row 'Персонажи' do |record|
        record.characters.map do |character|
          link_to(character.name, admin_character_path(character))
        end.join('<br>').html_safe
      end
      row :performance
      row :performance_date
      row :performance_duration
      row :stage
      row :address
      row :price
      row :partner_money
      row :partner_payed
      row :animator_money
      row :dopnik
      row :overheads
      row :child_age
      row :guests_count
      row :guests_age_from
      row :guests_age_to
      row :notice
      row :updated_at
    end
  end

  controller do

    def new
      @order = Order.new
      @order.is_new_order = false
      @order.is_new_stage = true

      if @order.is_new_order
        @customer = Customer.new
        @contact = Contact.new
      else
        @customer = Customer.last
        @contact = @customer.contacts.last
      end
      @order.performance_date = Date.today
      @order.performance_time = Time.now
    end

    def create
      # customer_constructor = OrderCustomerConstructor.new(order_params)
      # customer_constructor.process!
      stage_constructor = OrderStageConstructor.new(order_params)
      stage_constructor.process!
      redirect_to admin_orders_path
    end

    def edit

    end

    def update
      i = 3
    end

    def order_params
      params.require(:order).permit(
                              :is_new_order, :is_new_stage,
                              :stage_id, :customer_id, :contact_id,
                              customer: [:name, :customer_type],
                              contact: [:value, :notice],
                              stage: [:district, :street, :house, :apartment, :description]
      )
    end

  end

end


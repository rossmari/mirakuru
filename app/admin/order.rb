ActiveAdmin.register Order do

  permit_params :customer_id, :character_id, :stage_id, :address,
                :status, :price, :partner_money, :animator_money,
                :overheads, :payed, :child_name, :child_age, :guests_count,
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
      "#{record.child_name}<br>#{record.child_birthday} лет".html_safe
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

  show do |order|
    attributes_table do
      row :customer
      row :contact
      row :stage
      row :child_name
      row :child_birthday
      row :child_notice
      row 'Возраст гостей' do |record|
        "#{record.guests_age_from} - #{record.guests_age_to}"
      end
      row 'Дата и время' do |record|
        "#{record.performance_date.strftime('%Y.%m.%d')}, #{record.performance_time.strftime('%H:%M')}"
      end
      row :performance_duration do |record|
        "#{record.performance_duration} минут"
      end
      row :payed
      row :status do |record|
        t("admin.order.statuses.#{record.status}")
      end
      row 'Персонажи' do |record|
        record.characters.map do |character|
          link_to(character.name, admin_character_path(character))
        end.join('<br>').html_safe
      end
      row 'Источник заказа' do |record|
        t("admin.order.sources.#{record.source}")
      end
      # no performance (only invitations)
      # row :performance
      # no address (in stage )
      # row :address

      # total price ?
      row :price
      # total partner money? or partner percents?
      row :partner_money
      # in invitations ?
      # row :partner_payed
      # in invitations ?
      # row :animator_money
      # total ?
      row :dopnik
      # total ?
      row :overheads

      # row :guests_count

      row :notice
      row :updated_at

      table_for order.invitations do
        # column :id
        column 'Выступление' do |record|
          Order::Objects::Presenter.object_name(record.owner)
        end
        column :character
        column :actor do |invitation|
          link_to invitation.actor.name, admin_actor_path(invitation.actor)
        end
        column :status do |record|
          t("admin.invitation.statuses.#{record.status}")
        end
        column :start
        column :stop
        column :partner_payed
        column :price do |record|
          "#{record.price} р."
        end
        column :animator_money do |record|
          "#{record.animator_money} р."
        end
        column :overheads do |record|
          "#{record.overheads} р."
        end
        column :corrector
        # column :order_notice
        # column :actor_notice
        column :actions do |record|
          render partial: 'custom_links', locals: {record: record}
        end
      end
    end
  end

  controller do

    def new
      @resource_manager = ResourcesManager.new
      @manager = Order::NewManager.new
      @order = @manager.order
    end

    def edit
      @resource_manager = ResourcesManager.new
      @manager = Order::EditManager.new(params)
      @manager.prepare_params
      @order = @manager.order
    end

    def create
      customer_constructor = OrderCustomerConstructor.new(order_params)
      customer_constructor.process!
      order_params = customer_constructor.cut_params
      stage_constructor = OrderStageConstructor.new(order_params)
      stage_constructor.process!
      order_params = stage_constructor.cut_params
      invitation_params = order_params.delete(:invitations)
      @order = Order.new(order_params)
      @order.contact = customer_constructor.contact
      @order.customer = customer_constructor.customer
      @order.stage = stage_constructor.stage
      @order.save
      invitations_constructor = OrderInvitationsConstructor.new(invitation_params, @order)
      invitations_constructor.process!
      i = 3
    end

    def update
      customer_constructor = OrderCustomerConstructor.new(order_params)
      customer_constructor.process!
      order_params = customer_constructor.cut_params
      stage_constructor = OrderStageConstructor.new(order_params)
      stage_constructor.process!
      order_params = stage_constructor.cut_params
      invitation_params = order_params.delete(:invitations)
      @order = Order.find(params[:id])
      @order.assign_attributes(order_params)
      if @order.contact != customer_constructor.contact
        @order.contact = customer_constructor.contact
      end
      if @order.customer != customer_constructor.customer
        @order.customer = customer_constructor.customer
      end
      if @order.stage != stage_constructor.stage
        @order.stage = stage_constructor.stage
      end
      @order.save
      # todo : change invitations some how
      invitations_constructor = OrderInvitationsConstructor.new(invitation_params, @order)
      invitations_constructor.process!
      i = 3
    end

    def order_params
      params.require(:order).permit!
    end

  end

end


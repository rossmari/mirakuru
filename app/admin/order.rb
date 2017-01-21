ActiveAdmin.register Order do

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
      record.stage.name
    end
    column 'Дата и время' do |record|
      "#{record.performance_date.strftime('%Y.%m.%d')}, #{record.performance_time.strftime('%H:%M')}"
    end
    column 'Ребенок' do |record|
      record.child_name
    end
    column 'Гости' do |record|
      "#{record.guests_age_from} - #{record.guests_age_to} лет".html_safe
    end
    column :updated_at
    actions
  end

  form partial: 'form'

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
      row :status do |record|
        t("admin.order.statuses.#{record.status}")
      end
      row 'Источник заказа' do |record|
        t("admin.order.sources.#{record.source}")
      end
      row :partner_money
      row :additional_expense
      row :order_calculations_notice
      row :partner_payed
      row :exclude_additional_expense
      row :exclude_outcome
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


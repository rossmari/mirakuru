ActiveAdmin.register Invitation do

  actions :show, :index

  permit_params :status, :actor_id

  index do
    column :id
    column :order_id do |record|
      order = record.position.order
      link_to("Заказ #{order.id}", admin_order_path(order))
    end
    column :character do |record|
      character = record.position.character
      link_to(character.name, admin_character_path(character))
    end
    column :actor do |record|
      if record.actor
        record.actor.name
      else
        'Актер еще не выбран'
      end
    end
    column :status do |record|
      t("admin.invitation.statuses.#{record.status}")
    end
    column :updated_at
    actions
  end

  member_action :sent_to_all, method: :get do
    order = Order.find(params[:id])
    order.sent_invitations_to_all
    flash[:notice] = 'Приглашения отправлены'
    redirect_to admin_order_path(order)
  end

  member_action :fire_event, method: :get do
    invitation = Invitation.find(params[:id])
    event = params[:event_name]
    invitation.fire_events!(event)

    position_ids = Position.where(order_id: invitation.position.order_id).ids
    invitations = Invitation.where(position_id: position_ids)
    invitations =
      invitations.map do |i|
        {
          id: i.id,
          status: I18n.t("admin.invitation.statuses.#{i.status}"),
          events: i.admin_events.map{|event| {name: event, label: I18n.t("admin.invitation.events.#{event}")}}
        }
      end
    render json: { invitations: invitations }
  end

  controller do
    def update
      @invitation = Invitation.find(params[:id])
      @invitation.author = current_user
      if @invitation.update(permitted_params[:invitation])
        redirect_to admin_invitation_path(@invitation)
      else
        render 'edit'
      end
    end

    def destroy
      @invitation = Invitation.find(params[:id])
      @invitation.delete
    end
  end

  form do |f|
    f.inputs do
      f.input :start, as: :datepicker
      f.input :stop, as: :datepicker
      f.input :corrector
      f.input :actor_notice
      f.input :order_notice
      f.input :price
      f.input :animator_money
      f.input :overheads
      f.input :partner_payed
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :actor
      row :character
      row :order
      row :status do |record|
        t("admin.invitation.statuses.#{record.status}")
      end
      row 'Отправлено раз' do
        0
      end
      row :invitation_date do |record|
        record.invitation_date ? record.invitation_date : 'Еще не отправлено'
      end
      row :updated_at
    end
  end

end
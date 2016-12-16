ActiveAdmin.register Invitation do

  actions :show, :index, :sent_to_all, :edit, :update

  permit_params :status, :actor_id

  index do
    column :id
    column :order_id do |record|
      link_to("Заказ #{record.order_id}", admin_order_path(record.order))
    end
    column :character do |record|
      link_to(record.character.name, admin_character_path(record.character))
    end
    column :actor do |record|
      if record.actor
        record.actor.name
      else
        'Актер еще не выбран'
      end
    end
    column :status do |record|
      "<div class='invitation_status #{record.status}'>
      #{t("admin.invitation.statuses.#{record.status}")}
      </div>".html_safe
    end
    column 'Дата последней отправки' do |record|
      record.invitation_date ? record.invitation_date : 'Еще не отправлено'
    end
    column :updated_at
    actions defaults: true do |record|
      member_actions(record)
    end
  end

  member_action :sent_to_all, method: :get do

  end

  member_action :release, method: :get do
    resource.update(actor_id: nil)
    InvitationEvent.actor_removed!(resource, current_user)
    flash[:notice] = 'Приглашение освобождено!'
    redirect_to collection_path
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
  end

  form do |f|
    f.inputs do
      f.input :order,
              as: :select,
              collection: Order.all.map{|order| ["Заказ #{order.id}", order.id]},
              input_html: { disabled: true }
      f.input :character, as: :select,
              collection: Character.all.map{|character| [character.name, character.id]},
              input_html: { disabled: true }
      f.input :actor, as: :select,
        collection: Actor.all.map{|actor| [actor.name, actor.id]},
        include_blank: 'Аниматор не выбран'
      f.input :status, as: :select,
        collection: Invitation.statuses.map{|key, _value| [t("admin.invitation.statuses.#{key}"), key]},
        include_blank: false
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
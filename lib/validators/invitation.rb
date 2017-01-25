class Validators::Invitation

  attr_accessor :params, :errors, :order_instance,
                :is_new_order

  def initialize(params, is_new_order, order_instance)
    @params = params
    @errors = {invitations: {}}
    @order_instance = order_instance
    @is_new_order = is_new_order
  end

  def validate
    return unless params.present?

    params.each do |key, invitation_params|
      actors = invitation_params.delete(:actors)
      unless actors
        @errors[:invitations][key] = {}
        @errors[:invitations][key][:actors] = 'Необходимо выбрать актеров'
        actors = {'1' => '1'}
      end

      actors.each do |actor_id, checked|
        next unless to_bool(checked)

        invitation =
          if is_new_order
            invitation = find_invitation(invitation_params, actor_id)
            invitation.assign_attributes(invitation_params)
          else
            new_invitation(invitation_params, actor_id)
          end

        unless invitation.valid?
          @errors[:invitations][key].merge!(invitation.errors.to_h)
        end
      end

    end
  end

  def new_invitation(params, actor_id)
    invitation = Invitation.new(params)
    # invitation.order_id = order_instance.id
    invitation.actor_id = actor_id
    invitation
  end

  def find_invitation(params, actor_id)
    Invitation.find_by(order_id: order_instance.id,
                       owner_id: params[:owner_id],
                       owner_class: params[:owner_class], actor_id: actor_id)
  end

  def to_bool(param)
    param == '1'
  end

end

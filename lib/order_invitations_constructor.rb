class OrderInvitationsConstructor

  attr_accessor :params, :invitations, :order_instance

  def initialize(params, order_instance)
    @params = params
    @order_instance = order_instance
  end

  def process!
    create_invitations
  end

  private

  def create_invitations
    return unless params.present?

    params.each do |_key, invitation_params|
      actors = invitation_params.delete(:actors)
      actors.each do |actor_id, checked|
        next unless to_bool(checked)
        invitation = find_invitation(invitation_params, actor_id)
        if invitation
          # existing invitation, just update
          invitation.update(invitation_params)
        else
          # new invitation
          create_new_invitation(invitation_params, actor_id)
        end
      end

    end
  end

  def create_new_invitation(params, actor_id)
    invitation = Invitation.new(params)
    invitation.order_id = order_instance.id
    invitation.actor_id = actor_id
    invitation.save
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

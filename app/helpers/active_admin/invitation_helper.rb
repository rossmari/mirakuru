module ActiveAdmin::InvitationHelper

  def member_actions(invitation)
    actions = []

    unless invitation.actor
      actions << link_to('Разослать всем актерам', sent_to_all_admin_invitation_path(invitation), class: 'member_link')
    end

    if invitation.actor
      actions << link_to('Освободить', release_admin_invitation_path(invitation), class: 'member_link')
    end

    actions.join('<br>').html_safe
  end

end


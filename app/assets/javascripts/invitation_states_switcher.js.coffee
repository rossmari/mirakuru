$(document).ready ->

  renderActionUrl = (eventName, label, invitationId) ->
    '<a href="/admin/invitations/' + invitationId + '/fire_event?event_name=' + eventName + '">' + label + '</a>'

  renderActions = (events, invitationId) ->
    '<div class="actor_actions">' +
      $.map(events, (event) ->
        renderActionUrl(event.name, event.label, invitationId) + '<br>'
      ).join(' ') +
    '</div>'

  sendStateUpdate = (url, callback) ->
    $.ajax
      type: 'GET'
      url: url
      format: 'JSON'
      success: (data) ->
        callback(data.invitations)

  updateActionsBlock = (invitations) ->
    $.each(invitations, (index, invitation) ->
      block = $('.invitation_block[data-id="' + invitation.id + '"]')
      block.find('.actor_status').text(invitation.status)
      block.find('.actor_actions').html(renderActions(invitation.events, invitation.id))
    )

  # == Events
  $(document).on('click', '.actor_actions a', (event) ->
    event.preventDefault()
    url = $(this).prop('href')
    sendStateUpdate(url, updateActionsBlock)
  )
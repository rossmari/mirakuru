class Telegram::Callbacks::RefuseInvitation

  class << self

    def perform(response)
      invitation_id = JSON.parse(response.data)['data']['id']
      invitation = Invitation.find_by(id: invitation_id)
      invitation.actor_refused!
      [
        {
          header: message(invitation),
          buttons: invitation_buttons,
          type: type
        }
      ]
    end

    def message(invitation)
      [
        'Вы отказались от мероприятия',
        "#{header(invitation)}"
      ].join($RS)
    end

    def header(invitation)
      stage = invitation.order.stage
      date = invitation.start.strftime('%Y.%m.%d')
      start = invitation.start.strftime('%H:%M')
      stop = invitation.stop.strftime('%H:%M')
      "#{date}, #{start} - #{stop}, #{invitation.character.name}, #{stage.street}"
    end

    def invitation_buttons
      [
        Telegram::Bot::Types::InlineKeyboardButton.new(
          {
            text: 'Назад',
            callback_data: {processor: 'invitations'}.to_json
          }
        ),
        Telegram::Bot::Types::InlineKeyboardButton.new(
          {
            text: 'Меню',
            callback_data: {processor: 'start'}.to_json
          }
        )
      ]
    end

    def type
      :buttons
    end

  end
end
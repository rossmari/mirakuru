class Telegram::Callbacks::FreeInvitations

  class << self

    def perform(response)
      user = user(response)
      characters = user.characters.ids
      # search for free invitations with the characters for this actor
      invitations = Invitation.where(character_id: characters, actor_id: nil)
      [
        {
          header: invitations_list(invitations),
          buttons: invitation_buttons(invitations),
          type: type
        }
      ]
    end

    def invitation_buttons(invitations)
      result = []
      invitations.each_with_index do |invitation, index|
        result << Telegram::Bot::Types::InlineKeyboardButton.new(
          {
            text: "#{index + 1}. #{I18n.l(invitation.start, format: '%d %b, %H:%M')} - #{invitation.character.name}",
            callback_data: {processor: 'invitation', data: {id: invitation.id}}.to_json
          }
        )
      end
      result << Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Главное меню',
          callback_data: {processor: 'start' }.to_json
        }
      )
      result
    end

    def invitations_list(invitations)
      result = []
      invitations.each_with_index do |invitation, index|
        stage = invitation.order.stage
        date = invitation.start.strftime('%Y.%m.%d')
        start = invitation.start.strftime('%H:%M')
        stop = invitation.stop.strftime('%H:%M')
        result << "#{index + 1}) #{date}, #{start} - #{stop}, #{invitation.character.name}, #{stage.street}"
      end
      result << 'Нет подходящих предложений' if result.empty?
      result.join($RS)
    end

    def type
      :buttons
    end

    def user(response)
      Actor.find_by(telegram_key: response.from.id)
    end

  end
end
class Telegram::Callbacks::Invitation

  class << self

    def perform(response)
      invitation_id = JSON.parse(response.data)['data']['id']
      invitation = Invitation.find_by(id: invitation_id)
      [
        {
          header: invitation_description(invitation),
          buttons: invitation_buttons(invitation),
          type: type
        }
      ]
    end

    def invitation_buttons(invitation)
      [
        Telegram::Bot::Types::InlineKeyboardButton.new(
          {
            text: 'Отказаться от заказа',
            callback_data: {processor: 'refuse_invitation', data: {id: invitation.id}}.to_json
          }
        ),
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

    def invitation_description(invitation)
      [
        header(invitation),
        child(invitation),
        invitation.order_notice,
        "Адрес: #{invitation.order.stage.address}.",
        company(invitation),
        "Заказ #{invitation.partner_payed ? 'оплачен' : 'не оплачен'}.",
        "Стоймость заказа: #{invitation.price} рублей.",
        "ЗП: #{invitation.animator_money} рублей. (id: #{invitation.id})"
      ].join($RS)
    end

    def header(invitation)
      stage = invitation.order.stage
      date = invitation.start.strftime('%Y.%m.%d')
      start = invitation.start.strftime('%H:%M')
      stop = invitation.stop.strftime('%H:%M')
      "#{date}, #{start} - #{stop}, #{invitation.character.name}, #{stage.street}"
    end

    def company(invitation)
      invitations = Invitation.where(order_id: invitation.order_id).where.not(character_id: invitation.character_id)
      if invitations.any?
        "(+#{invitations.count} персонажей: #{invitations.map{|i| i.character.name}.join(', ')})"
      else
        ''
      end
    end

    def child(invitation)
      "Ребенка зовут #{invitation.order.child_name}, #{invitation.order.child_notice}"
    end

    def type
      :buttons
    end

    def user(response)
      Actor.find_by(telegram_key: response.from.id)
    end

  end
end
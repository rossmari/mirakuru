class Telegram::Callbacks::Invitation < Telegram::Base::Invitation

  private

  def buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Отказаться от заказа',
          callback_data: {processor: 'cancel_invitation', data: {id: invitation.id}}.to_json
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

end
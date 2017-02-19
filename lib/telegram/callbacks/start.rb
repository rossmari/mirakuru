class Telegram::Callbacks::Start < Telegram::Base::Callback

  private

  def header
    ['- Главное меню - ']
  end

  def buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Мои мероприятия',
          callback_data: { processor: 'invitations' }.to_json
        }
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Заявки',
          callback_data: { processor: 'invited_invitations' }.to_json
        },
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Отказы',
          callback_data: { processor: 'rejected_invitations' }.to_json
        },
      )
    ]
  end

end
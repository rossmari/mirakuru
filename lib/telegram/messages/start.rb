class Telegram::Messages::Start

  class << self

    def perform(_response)
      {
        header: '- Главное меню - ',
        buttons: [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            {
              text: 'Мои мероприятия',
              callback_data: { processor: 'invitations' }.to_json
            }
          ),
          Telegram::Bot::Types::InlineKeyboardButton.new(
            {
              text: 'Заявки',
              callback_data: { processor: 'free_invitations' }.to_json
            },
          ),
          Telegram::Bot::Types::InlineKeyboardButton.new(
            {
              text: 'Отказы, актуальные',
              callback_data: { processor: 'zzz' }.to_json
            },
          )
        ]
      }
    end

    def type
      :buttons
    end

  end
end
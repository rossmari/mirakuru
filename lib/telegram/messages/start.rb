class Telegram::Messages::Start

  class << self

    def perform(_response)
      {
        header: '- Главное меню - ',
        buttons: [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Мои мероприятия', callback_data: 'retrieve_code'),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Мероприятия', callback_data: 'retrieve_code'),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Заявки', callback_data: 'retrieve_code')
        ]
      }
    end

    def type
      :buttons
    end

  end
end
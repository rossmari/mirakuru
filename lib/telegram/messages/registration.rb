class Telegram::Messages::Registration

  class << self

    def perform(_response)
      {
        header: 'Получение кода',
        buttons: [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Получить код', callback_data: 'retrieve_code')
        ]
      }
    end

    def type
      :buttons
    end

  end
end
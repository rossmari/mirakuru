class Telegram::Support

  class << self
    def extract_chat_id(response)
      case response
        when Telegram::Bot::Types::CallbackQuery
          response.from.id
        when Telegram::Bot::Types::Message
          response.chat.id
      end
    end

    def user_registered?(params)
      user_id = params.from.id
      Actor.where(telegram_key: user_id).any?
    end
  end

end
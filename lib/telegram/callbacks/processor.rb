class Telegram::Callbacks::Processor

  PROCESSORS_LIST = {
    retrieve_code: Telegram::Callbacks::RetrieveCode
  }

  class << self

    def perform(message)
      callback_name = message.data
      processor = PROCESSORS_LIST[callback_name.to_sym]
      response = processor.perform(message)

      if processor.type == :message
        bot.api.send_message(chat_id: message.from.id, text: response)
      elsif processor.type == :buttons
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: response[:buttons])
        bot.api.send_message(chat_id: message.from.id, text: response[:header], reply_markup: markup)
      end
    end

    def bot
      $bot
    end
  end
end
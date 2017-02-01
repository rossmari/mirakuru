class Telegram::Messages::Processor

  PROCESSORS_LIST = {
    registration: Telegram::Messages::Registration,
    already_registered: Telegram::Messages::AlreadyRegistered,
    undefined: Telegram::Messages::Undefined,
    start: Telegram::Messages::Start
  }

  class << self

    def perform(message)
      # if user type not-commands then do nothing
      return nil if message.text[0] != '/'

      processor = PROCESSORS_LIST[message.text.sub('/', '').to_sym]
      processor ||= PROCESSORS_LIST[:undefined]

      # special cases
      response =
        case message.text
          when '/registration'
            if !Telegram::Support.user_registered?(message)
              processor.perform(message)
            else
              processor = PROCESSORS_LIST[:already_registered]
              processor.perform(nil)
            end
          else
            processor.perform(message)
        end

      if processor.type == :message
        bot.api.send_message(chat_id: message.chat.id, text: response)
      elsif processor.type == :buttons
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: response[:buttons])
        bot.api.send_message(chat_id: message.chat.id, text: response[:header], reply_markup: markup)
      end
    end

    def bot
      $bot
    end
  end

end
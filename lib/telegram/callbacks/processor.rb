class Telegram::Callbacks::Processor

  PROCESSORS_LIST = {
    retrieve_code: Telegram::Callbacks::RetrieveCode,
    undefined: Telegram::Callbacks::Undefined,
    invitations: Telegram::Callbacks::Invitations,
    invitation: Telegram::Callbacks::Invitation,
    start: Telegram::Callbacks::Start
  }

  class << self

    def perform(message)
      data = JSON.parse(message.data)
      processor = PROCESSORS_LIST[data['processor'].to_sym] || PROCESSORS_LIST[:undefined]
      responses = processor.perform(message)

      Array.wrap(responses).each do |response|
        case response[:type]
          when :message
            bot.api.send_message(chat_id: message.from.id, text: response[:text])
          when :buttons
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: response[:buttons])
            bot.api.send_message(chat_id: message.from.id, text: response[:header], reply_markup: markup)
          else
            bot.api.send_message(chat_id: message.from.id, text: 'Unknown response type')
        end
      end
    end

    def bot
      $bot
    end
  end
end
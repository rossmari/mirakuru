class Telegram::Callbacks::Processor

  PROCESSORS_LIST = {
    retrieve_code: Telegram::Callbacks::RetrieveCode,
    undefined: Telegram::Callbacks::Undefined,
    invitations: Telegram::Callbacks::Invitations,
    invitation: Telegram::Callbacks::Invitation,
    start: Telegram::Callbacks::Start,
    refuse_invitation: Telegram::Callbacks::RefuseInvitation,
    free_invitations: Telegram::Callbacks::FreeInvitations,
    free_invitation: Telegram::Callbacks::FreeInvitation,
    accept_invitation: Telegram::Callbacks::AcceptInvitation,
    cancel_invitation: Telegram::Callbacks::CancelInvitation,
    create_invitation: Telegram::Callbacks::CreateInvitation
  }

  class << self

    def perform(message)
      data = JSON.parse(message.data)
      processor_class = PROCESSORS_LIST[data['processor'].to_sym] || PROCESSORS_LIST[:undefined]
      processor = processor_class.new(message)

      response = processor.create_response
      recipient_id = message.from.id

      send_responses(response, recipient_id)
    end

    def send_responses(responses, recipient_id)
      Array.wrap(responses).each do |response|
        case response[:type]
          when :message
            bot.api.send_message(chat_id: recipient_id, text: response[:text])
          when :buttons
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: response[:buttons])
            bot.api.send_message(chat_id: recipient_id, text: response[:header], reply_markup: markup)
          else
            bot.api.send_message(chat_id: recipient_id, text: 'Unknown response type')
        end
      end
    end

    def bot
      $bot
    end

  end
end

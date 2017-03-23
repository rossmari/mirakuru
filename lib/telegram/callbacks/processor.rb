class Telegram::Callbacks::Processor

  PROCESSORS_LIST = {
    retrieve_code: Telegram::Callbacks::RetrieveCode,
    undefined: Telegram::Callbacks::Undefined,
    invitations: Telegram::Callbacks::Invitations,
    invitation: Telegram::Callbacks::Invitation,
    start: Telegram::Callbacks::Start,
    refuse_invitation: Telegram::Callbacks::RefuseInvitation,
    invited_invitations: Telegram::Callbacks::InvitedInvitations,
    invited_invitation: Telegram::Callbacks::InvitedInvitation,
    accept_invitation: Telegram::Callbacks::AcceptInvitation,
    cancel_invitation: Telegram::Callbacks::CancelInvitation,
    create_invitation: Telegram::Callbacks::CreateInvitation,
    rejected_invitations: Telegram::Callbacks::RejectedInvitations,
    rejected_invitation: Telegram::Callbacks::RejectedInvitation
  }

  class << self

    def perform(message)
      recipient_id = message.from.id
      data = JSON.parse(message.data)
      processor_class = PROCESSORS_LIST[data['processor'].to_sym] || PROCESSORS_LIST[:undefined]
      processor = processor_class.new(message)

      response = processor.create_response

      send_responses(response, recipient_id)
    rescue => e
      bot.api.send_message(chat_id: recipient_id, text: "Exception raised #{e}")
    end

    def send_responses(responses, recipient_id)
      return if recipient_id.blank?

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
    rescue => e
      # raise("Unable to send response: #{e}")
    end

    def bot
      $bot
    end

  end
end

class Telegram::Callbacks::RejectedInvitation < Telegram::Base::Invitation

  private

  def buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Принять',
          callback_data: {processor: 'accept_invitation', data: {id: invitation.id}}.to_json
        }
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Назад',
          callback_data: {processor: 'rejected_invitations'}.to_json
        }
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Главное меню',
          callback_data: {processor: 'start'}.to_json
        }
      )
    ]
  end

end
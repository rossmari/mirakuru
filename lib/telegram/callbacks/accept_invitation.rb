class Telegram::Callbacks::AcceptInvitation < Telegram::Base::DataCallback

  private

  def perform_actions
    invitation.fire_events!(:accept)
  end

  def header
    [
      'Вы назначены на эту роль, поздравляем!'
    ]
  end

  def buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Главное меню',
          callback_data: {processor: 'start' }.to_json
        }
      )
    ]
  end

end
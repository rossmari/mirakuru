class Telegram::Callbacks::CancelInvitation < Telegram::Base::DataCallback

  private

  def perform_actions
    invitation.fire_events!(:cancel)
  end

  def header
    [
      'Вы отказались от этого заказа!'
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
class Telegram::AdminSender::Assign < Telegram::Base::Invitation

  def initialize(invitation)
    @invitation = invitation
    @position = invitation.position
    @order = position.order
  end

  private

  def header
    ['- Вы назначены Администратором - '] + invitation_description
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
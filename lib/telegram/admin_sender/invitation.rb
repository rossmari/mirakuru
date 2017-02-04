class Telegram::AdminSender::Invitation < Telegram::Base::Invitation

  def initialize(invitation)
    @invitation = invitation
    @position = invitation.position
    @order = position.order
  end

  private

  def header
    ['- Новый заказ - '] + invitation_description
  end

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
          text: 'Отказаться',
          callback_data: {processor: 'refuse_invitation', data: {id: invitation.id}}.to_json
        }
      )
    ]
  end

end
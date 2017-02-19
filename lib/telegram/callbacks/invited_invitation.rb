class Telegram::Callbacks::InvitedInvitation < Telegram::Base::Invitation
  # this callback do not search real invitation
  # it shows to user template of invitation
  # for free position

  def initialize(response)
    @invitation = parse_invitation(response)
    @position = @invitation.position
    @order = position.order
    perform_actions
  end

  private

  def buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'Принять заказ',
          callback_data: {processor: 'accept_invitation', data: {id: @invitation.id}}.to_json
        }
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'К заявкам',
          callback_data: {processor: 'invited_invitations'}.to_json
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
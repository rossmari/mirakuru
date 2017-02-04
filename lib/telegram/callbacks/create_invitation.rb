class Telegram::Callbacks::CreateInvitation < Telegram::Base::Invitation
  # this callback do not search real invitation
  # it shows to user template of invitation
  # for free position

  def initialize(response)
    @position = parse_position(response)
    @order = position.order
    actor = Actor.find_by(telegram_key: response.from.id)
    @invitation = Invitation.find_or_initialize_by(actor_id: actor.id, position: position)
    perform_actions
  end

  private

  def perform_actions
    # save only new invitations
    unless invitation.persisted?
      invitation.save!
      invitation.fire_events!(:accept)
    end
  end

  def parse_position(response)
    position_id = JSON.parse(response.data)['data']['position_id']
    Position.find_by(id: position_id)
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
      ),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: 'К заявкам',
          callback_data: {processor: 'free_invitations'}.to_json
        }
      )
    ]
  end

end
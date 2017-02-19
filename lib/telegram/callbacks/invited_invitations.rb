class Telegram::Callbacks::InvitedInvitations < Telegram::Base::DataCallback
  # where actor was invited

  include Telegram::Base::Common

  attr_reader :invitations, :actor

  def initialize(response)
    response = response
    @actor = Actor.find_by(telegram_key: response.from.id)

    # search all actual positions for current time moment
    positions = Position.where('start > ?', DateTime.now)

    # search for invitation that was sent to actor before (actor not accept them yet)
    @invitations = Invitation.where(actor_id: actor.id,
                                    position: positions,
                                    status: Invitation.statuses[:sent])
  end

  private

  def header
    result = []
    invitations.each_with_index do |invitation, index|
      result << "#{index + 1}) #{position_short_name(invitation.position)}"
    end
    result << 'Нет мероприятий' if result.empty?
    result
  end

  def buttons
    result = []
    invitations.each_with_index do |invitation, index|
      result << Telegram::Bot::Types::InlineKeyboardButton.new(
        {
          text: "#{index + 1}. #{invitation_title(invitation.position)} (#{invitation.id})",
          callback_data:
            {
              processor: 'invited_invitation',
              data: {id: invitation.id}
            }.to_json
        }
      )
    end
    result << Telegram::Bot::Types::InlineKeyboardButton.new(
      {
        text: 'Главное меню',
        callback_data: { processor: 'start' }.to_json
      }
    )
  end

  def invitation_title(position)
    "#{I18n.l(position.start, format: '%d %b, %H:%M')} - #{position.character.name}"
  end

end
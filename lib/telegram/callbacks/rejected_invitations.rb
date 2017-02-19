class Telegram::Callbacks::RejectedInvitations < Telegram::Base::DataCallback
  include Telegram::Base::Common
  attr_reader :invitations, :actor

  # select only canceled or refused invitations
  # which is still actual - position is not closed yet
  def initialize(response)
    response = response
    actor = Actor.find_by(telegram_key: response.from.id)
    statuses = [
      Invitation.statuses[:canceled],
      Invitation.statuses[:refused]
    ]
    positions = Position.where('start > ?', DateTime.now)
    # remove closed positions
    # no need to filter, rejected will be closed if some one accept this position
    # positions = reject_closed_positions(positions)

    @invitations = Invitation.where(actor_id: actor.id, status: statuses, position: positions)
  end

  private

  def reject_closed_positions(positions)
    statuses = %w(accepted assigned)
    positions.reject do |position|
      position_statuses = position.invitations.map(&:status)
      (statuses & position_statuses).any?
    end

  end

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
          text: "#{index + 1}. #{invitation_title(invitation.position)}",
          callback_data:
            {
              processor: 'rejected_invitation',
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
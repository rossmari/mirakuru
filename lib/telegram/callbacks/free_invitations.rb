class Telegram::Callbacks::FreeInvitations < Telegram::Base::DataCallback
  include Telegram::Base::Common

  attr_reader :invitations, :actor

  def initialize(response)
    response = response
    @actor = Actor.find_by(telegram_key: response.from.id)
    character_ids = actor.characters.ids

    # search all positions with actor characters
    positions = Position.where('start > ?', DateTime.now).where(character_id: character_ids)

    free_positions = filter_positions(positions)

    # and now we have free positions list
    # create temporary invitations
    @invitations =
      free_positions.map do |position|
        Invitation.new(actor_id: actor.id, position: position)
      end
  end

  def filter_positions(positions)
    # reject position where invitations are
    # accepted or assigned (position is occupied already)
    statuses = [ :accepted, :assigned ]
    positions.reject do |position|
      occupied = (position.invitations.map{|i| i.status.to_sym} & statuses).any?
      closed_for_actor =
        position.invitations.any? do |i|
          i.actor_id == actor.id && [:closed, :refused].include?(i.status.to_sym)
        end
      occupied || closed_for_actor
    end
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
          text: "#{index + 1}. #{invitation_title(invitation.position)}",
          callback_data:
            {
              processor: 'free_invitation',
              data: {position_id: invitation.position.id}
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
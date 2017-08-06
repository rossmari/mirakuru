class Telegram::Callbacks::Invitations < Telegram::Base::DataCallback
  include Telegram::Base::Common

  attr_reader :invitations

  def initialize(response)
    response = response
    actor = Actor.find_by(telegram_key: response.from.id)
    statuses = [
      ::Invitation.statuses[:accepted],
      ::Invitation.statuses[:assigned]
    ]
    @invitations = ::Invitation.where(actor_id: actor.id, status: statuses)
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
              processor: 'invitation',
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
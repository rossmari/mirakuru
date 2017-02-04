class Telegram::Base::DataCallback

  attr_reader :invitation, :position, :order

  def initialize(response)
    @invitation = parse_invitation(response)
    @position = invitation.position
    @order = position.order

    perform_actions
  end

  def perform_actions
    # in base - do nothing
  end

  def create_response
    [
      {
        # header, or text - as invitation full description
        # header is an Array, so we join it with new lines
        header: header.join($RS),
        buttons: buttons,
        type: type
      }
    ]
  end

  private

  def parse_invitation(response)
    invitation_id = JSON.parse(response.data)['data']['id']
    Invitation.find_by(id: invitation_id)
  end

  def type
    :buttons
  end

end
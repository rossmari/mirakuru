class Telegram::Base::Callback

  attr_reader :response

  def initialize(response)
    @response = response

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

  def header
    raise NotImplementedError.new('You need to implement header block')
  end

  def buttons
    raise NotImplementedError.new('You need to implement buttons block')
  end

  def type
    :buttons
  end

end
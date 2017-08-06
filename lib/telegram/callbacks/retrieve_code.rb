class Telegram::Callbacks::RetrieveCode < Telegram::Base::Callback

  def create_response
    [
      {
        # header, or text - as invitation full description
        # header is an Array, so we join it with new lines
        text: "Ваш код: #{response.from.id}",
        type: :message
      }
    ]
  end

end
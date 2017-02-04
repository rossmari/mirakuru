class Telegram::Callbacks::RetrieveCode < Telegram::Base::Callback

  private

  def create_response
    [
      {
        text: "Ваш код: #{response.from.id}",
        type: type
      }
    ]
  end

  def type
    :message
  end

end
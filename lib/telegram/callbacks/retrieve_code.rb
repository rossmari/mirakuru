class Telegram::Callbacks::RetrieveCode

  class << self

    def perform(response)
      {
        text: "Ваш код: #{response.from.id}",
        type: type
      }
    end

    def type
      :message
    end

  end
end
class Telegram::Callbacks::RetrieveCode

  class << self

    def perform(response)
      "Ваш код: #{response.from.id}"
    end

    def type
      :message
    end

  end
end
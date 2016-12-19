class Telegram::Messages::Undefined

  class << self

    def perform(_response)
      'Неизвестная команда.'
    end

    def type
      :message
    end

  end
end
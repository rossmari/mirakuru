class Telegram::Messages::AlreadyRegistered

  class << self

    def perform(_response)
      'Вы уже зарегестрированы.'
    end

    def type
      :message
    end

  end
end
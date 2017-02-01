class Telegram::Callbacks::Undefined

  class << self

    def perform(_response)
      {
        text: 'Неизвестная команда.',
        type: type
      }
    end

    def type
      :message
    end

  end
end
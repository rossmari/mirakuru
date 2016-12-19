class TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    response = nil
    if params.keys.include?('callback_query')
      response = Telegram::Bot::Types::CallbackQuery.new(params['callback_query'])
    elsif params.keys.include?('message')
      response = Telegram::Bot::Types::Message.new(params['message'])
    end

    case response
      when Telegram::Bot::Types::CallbackQuery
        # Here you can handle your callbacks from inline buttons
        Telegram::Callbacks::Processor.perform(response)
      when Telegram::Bot::Types::Message
        Telegram::Messages::Processor.perform(response)
    end
    render status: 200, json: 'success'
  end

end

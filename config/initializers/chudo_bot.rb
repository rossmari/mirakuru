require 'net/http'
require 'telegram/bot'

# token = Gnome.read('telegram_token')
#
# $bot = Telegram::Bot::Client.new(token)
#
# Thread.new do
#   Telegram::Bot::Client.run(token) do |bot|
#     bot.listen do |message|
#       case message
#         when Telegram::Bot::Types::CallbackQuery
#           # Here you can handle your callbacks from inline buttons
#           Telegram::Callbacks::Processor.perform(message)
#         when Telegram::Bot::Types::Message
#           Telegram::Messages::Processor.perform(message)
#       end
#     end
#   end
# end
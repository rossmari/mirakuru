require 'net/http'
require 'telegram/bot'

token = ENV['telegram_token']

service_url =
  if Rails.env.development?
    'https://roman.pagekite.me/telegram'
  elsif Rails.env.production?
    ENV['service_hook_url']
  end

uri = URI("https://api.telegram.org/bot#{token}/setWebhook")
params = { url: service_url }
uri.query = URI.encode_www_form(params)

# register web hook only for development
if Rails.env.development?
  res = Net::HTTP.get_response(uri)
  if res.is_a?(Net::HTTPSuccess)
    puts res.body
  else
    puts res.body
    puts 'Unable to register web hook'
  end
end

$bot = Telegram::Bot::Client.new(token)
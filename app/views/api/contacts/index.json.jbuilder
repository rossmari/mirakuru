json.code 200
json.message 'success'

json.contacts @contacts do |contact|
  json.name "#{contact.value} / #{contact.notice}"
  json.id contact.id
end
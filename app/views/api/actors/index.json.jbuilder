json.code 200
json.message 'success'

json.actors @actors do |actor|
  json.name actor.name
  json.id actor.id
  json.characters actor.characters.map(&:id)
  json.invitations @invitations[actor.id]
end
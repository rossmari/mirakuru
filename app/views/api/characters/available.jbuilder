json.code 200
json.message 'success'
json.count @characters.count

json.characters @characters do |character|
  json.name character.name
  json.id character.id
end
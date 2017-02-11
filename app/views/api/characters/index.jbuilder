json.code 200
json.message 'success'
json.count @characters.count

json.characters @characters do |character|
  json.name Order::Objects::Presenter.object_name(character)
  json.id character.id
end
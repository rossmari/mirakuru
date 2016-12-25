json.code 200
json.message 'success'

json.stages @stages do |stage|
  json.name stage.name
  json.id stage.id
end
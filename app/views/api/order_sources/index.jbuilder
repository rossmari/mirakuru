json.code 200
json.message 'success'

json.sources @sources do |source|
  json.value source.value
  json.id source.id
end
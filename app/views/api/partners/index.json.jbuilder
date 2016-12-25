json.code 200
json.message 'success'

json.partners @partners do |partner|
  json.name partner.name
  json.id partner.id
end
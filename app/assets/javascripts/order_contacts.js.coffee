$(document).ready ->

  optionsList = (objects) ->
    options = ['<option value="">Не выбрано</option>']
    $.each(objects, (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.name + '</option>'

  loadContacts = (customerId, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/contacts?customer_id=' + customerId
      format: 'JSON'
      success: (data) ->
        callback(data.contacts)

  # ======== events
  $('.updater').on('click', (event) ->
    event.preventDefault()
    customerId = $('#order_customer_id').prop('value')
    loadContacts(customerId, (contacts) ->
      options = optionsList(contacts)
      element = $('#order_contact_id')
      element.find('option').remove()
      element.append(options)
    )
  )
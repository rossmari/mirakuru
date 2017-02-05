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

  checkContact = (contactValue, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/contacts/check?value=' + contactValue
      format: 'JSON'
      success: (data) ->
        callback(data.uniq_value)


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

  $('#contact_value').on('focusout', (event) ->
    input = $(this)
    checkContact(input.prop('value'), (isUniq) ->
      if !isUniq
        input.addClass('with_error')
        input.parent().find('.error_message').text('Такой контакт уже существует')
      else
        input.removeClass('with_error')
        input.parent().find('.error_message').text('')
    )
  )
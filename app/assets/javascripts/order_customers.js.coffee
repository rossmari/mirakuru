$(document).ready ->
  customersList = {}
  contactsList = {}

  updateCustomerTypeButtons = (button) ->
    $('.customer_type_switcher').prop('class', 'customer_type_switcher btn btn-default')
    button.prop('class', 'customer_type_switcher btn btn-primary')

  updateCustomerTypeValue = (element) ->
    typeValue = element.data('value')
    $('#customer_type').prop('value', typeValue)

  updateCustomerModeValue = (element) ->
    modeValue = element.data('value')
    $('#order_mode').prop('value', modeValue)

  updateCustomerInputs = (element) ->
    $('.customer_switcher').prop('class', 'customer_switcher btn btn-default')
    element.prop('class', 'customer_switcher btn btn-primary')

    $('.customer_block').hide()
    $('.' + element.data('object')).show()

  loadCustomerContacts = (customerId, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/contacts?customer_id=' + customerId
      format: 'JSON'
      success: (data) ->
        callback(data.contacts)

  preloadCustomers = ->
    $.ajax
      type: 'GET'
      url: '/api/customers'
      format: 'JSON'
      success: (data) ->
        customersList = data.customers
        console.log('Preload customers list ---')
        console.log(customersList)

  optionFromContact = (contact) ->
    '<option value="' + contact.id + '">' + contact.name + '</option>'

  updateContactSelectorOptions = (contactsList) ->
    selector = $('#order_contact_id')
    # remove old options
    selector.find('option').remove()
    # add new options
    newContactsOptions = $.map(contactsList, (contact) ->
      optionFromContact(contact)
    )
    selector.append(newContactsOptions)

  # ============= events
  # change customer select mode - new customer fields or existing customer selectors
  $('.customer_switcher').on('click', (event)->
    event.preventDefault()
    updateCustomerInputs($(this))
    updateCustomerModeValue($(this))
  )
  # change customer type - physical or partners
  $('.customer_type_switcher').on('click', (event)->
    event.preventDefault()
    updateCustomerTypeValue($(this))
    updateCustomerTypeButtons($(this))
  )
  # ============= load contacts for selected customer
  $('#order_customer_id').on('click', (event) ->
    customerId = $(this).prop('value')
    loadCustomerContacts(customerId, updateContactSelectorOptions)
  )
  # ============= initial state
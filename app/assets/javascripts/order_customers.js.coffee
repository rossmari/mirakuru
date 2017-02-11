$(document).ready ->
  customersList = {}
  contactsList = {}

  updateCustomerTypeButtons = (button) ->
    $('.customer_type_switcher').prop('class', 'customer_type_switcher btn btn-default')
    button.prop('class', 'customer_type_switcher btn btn-primary')

  updateCustomerTypeValue = (element) ->
    typeValue = element.data('value')
    $('#customer_type').prop('value', typeValue)
    refreshCustomersList()

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
    customersList = JSON.parse($('#customer_serialized').prop('value'))

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
    selector.trigger('change')

  updateCustomersSelectorOptions = (customers) ->
    selector = $('#customer_selector')
    # remove old options
    selector.find('option').remove()
    # add new options
    newCustomersOptions = $.map(customers, (customer) ->
      optionFromContact(customer)
    )
    selector.append(newCustomersOptions)
    selector.trigger('change')

  filterCustomer = (type) ->
    $.grep(customersList, (customer) ->
      customer.type == parseInt(type)
    )

  refreshCustomersList = ->
    customerType = $('#customer_type').prop('value')
    console.log('Type: ' + customerType)
    customers = filterCustomer(customerType)
    updateCustomersSelectorOptions(customers)

  changeSourceFieldVisibility = (customerType) ->
    # repeat (hide source)
    if customerType == 0
      $('.source_template_part').hide()
    # new customer - show source
    else if customerType == 1
      $('.source_template_part').show()


  # ============= events
  # change customer select mode - new customer fields or existing customer selectors
  $('.customer_switcher').on('click', (event)->
    event.preventDefault()
    updateCustomerInputs($(this))
    updateCustomerModeValue($(this))
    changeSourceFieldVisibility($(this).data('value'))
  )
  # change customer type - physical or partners
  $('.customer_type_switcher').on('click', (event)->
    event.preventDefault()
    updateCustomerTypeValue($(this))
    updateCustomerTypeButtons($(this))
  )
  # ============= load contacts for selected customer
  $('#customer_selector').on('change', (event) ->
    customerId = $(this).prop('value')
    loadCustomerContacts(customerId, updateContactSelectorOptions)
  )

  # ============= initial state
  preloadCustomers()
  refreshCustomersList()
$(document).ready ->
  errorsCollection = {}

  validateOrder = (serializedOrder) ->
    $.ajax
      type: 'POST'
      url: '/api/orders/validate'
      dataType: 'JSON'
      data: serializedOrder
      success: (data) ->
        errorsCollection = data.errors
        console.log(errorsCollection)
        $.each(Object.keys(errorsCollection), (index, key) ->
          $('*[name="' + key + '"]').parent().find('.error_container').text(errorsCollection[key])
          $('*[name="' + key + '"]').addClass('with_error')
        )

  $('#order_form').on('submit', (event) ->

    event.preventDefault()
    serializedForm = $(this).serializeObject()
    delete serializedForm['_method']
    validateOrder(serializedForm)

    console.log('validate this -- ')
    console.log(serializedForm)

  )

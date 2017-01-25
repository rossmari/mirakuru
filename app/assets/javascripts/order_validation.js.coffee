$(document).ready ->
  errorsCollection = {}

  flushAllErrors = ->
    flushError($('input'))
    flushError($('select'))

  flushError = (element) ->
    element.parents('.error_container').find('.error_message').text('')
    element.removeClass('with_error')

  validateOrder = (serializedOrder) ->
    flushAllErrors()

    $.ajax
      type: 'POST'
      url: '/api/orders/validate'
      dataType: 'JSON'
      data: serializedOrder
      success: (data) ->
        errorsCollection = data.errors

        if(Object.keys(errorsCollection ).length > 0)
          $.each(Object.keys(errorsCollection), (index, key) ->
            $('*[name="' + key + '"]').parents('.error_container').find('.error_message').text(errorsCollection[key])
            $('*[name="' + key + '"]').addClass('with_error')
          )
        else
          $('#order_form').submit()

  $('#submit_order_btn').on('click', (event) ->
    event.preventDefault()
    serializedForm = $('#order_form').serializeObject()
    delete serializedForm['_method']
    validateOrder(serializedForm)
  )

  $('input').on('change', (event) ->
    flushError($(this))
  )

  $('select').on('change', (event) ->
    flushError($(this))
  )

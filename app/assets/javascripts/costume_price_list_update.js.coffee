$(document).ready ->

  updatePriceItem = (itemId, value, fieldName) ->
    data = { costume_price_position: {} }
    data['costume_price_position'][fieldName] = value
    $.ajax
      type: 'PUT'
      data: data,
      url: '/api/costume_price_positions/' + itemId
      success: (data) ->
        console.log('Sent!')


  $('input').on('focusout', (event) ->
    inputName = $(this).prop('name')
    matches = inputName.match(/(\S+)_(\d+)/)
    attributeName = matches[1]
    itemId = matches[2]
    value = $(this).prop('value')
    updatePriceItem(itemId, value, attributeName)
  )
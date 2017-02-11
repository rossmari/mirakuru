$(document).ready ->

  loadPrice = (customerType, time, animatorsCount, callback) ->
    $.ajax
      type: 'GET'
      url: '/api/price_positions?time=' + time + '&customer_type=' + customerType + '&animators_count=' + animatorsCount
      success: (data) ->
        callback(data)

  #======== Events
  $(document).on('click', '.load_from_price', (event) ->
    customerType = $('#customer_type').prop('value')
    time = $('#order_performance_duration').prop('value')
    input = $(this).parents('.input-group').find('input')
    attribute = $(this).data('attribute')
    animatorsCount = $('.order_object').length
    loadPrice(customerType, time, animatorsCount, (priceObject) ->
      input.prop('value', parseFloat(priceObject[attribute]))
    )
  )
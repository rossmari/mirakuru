$(document).ready ->
  inputsByPrice = {}

  loadPrice = (callback) ->
    time = getTime()
    customerId = getCustomerId()
    animatorsCount = getAnimatorsCount()
    $.ajax
      type: 'GET'
      url: '/api/price_positions?time=' + time + '&customer_id=' + customerId + '&animators_count=' + animatorsCount
      success: (data) ->
        callback(data)

  addInputToAutoList = (element) ->
    element.addClass('value_by_price')
    name = element.prop('name')
    inputsByPrice[name] = true
    console.log(inputsByPrice)

  removeInputFromAutoList = (element) ->
    element.removeClass('value_by_price')
    name = element.prop('name')
    inputsByPrice[name] = false
    console.log(inputsByPrice)

  getCustomerId = ->
    $('#customer_selector').prop('value')

  getTime = ->
    $('#order_performance_duration').prop('value')

  getAnimatorsCount = ->
    $('.order_object').length

  extractAttributeName = (name) ->
    name.match(/\[\d+\]\[(\S+)\]/)[1]

  recalculateAllAutoValues = ->
    $.each(Object.keys(inputsByPrice), (index, name) ->
      if inputsByPrice[name]

        input = $('input[name="' + name + '"]')
        attribute = extractAttributeName(name)
        loadPrice((priceObject) ->
          input.prop('value', parseFloat(priceObject[attribute]))
          $('#partner_money_percents').trigger('keyup')
        )
    )

  #======== Events
  $(document).on('click', '.load_from_price', (event) ->
    input = $(this).parents('.input-group').find('input')
    attribute = extractAttributeName(input.prop('name'))

    loadPrice((priceObject) ->
      input.prop('value', parseFloat(priceObject[attribute]))
      addInputToAutoList(input)
      $('#partner_money_percents').trigger('keyup')
    )
  )

  $(document).on('change', '.position_price', (event) ->
    removeInputFromAutoList($(this))
  )

  $(document).on('change', '.position_animator_money', (event) ->
    removeInputFromAutoList($(this))
  )

  $(document).on('change', '.order_object_selector', (event) ->
    recalculateAllAutoValues()
  )

  $(document).on('change', '#customer_selector', (event) ->
    recalculateAllAutoValues()
  )



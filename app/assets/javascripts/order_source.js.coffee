$(document).ready ->

  loadOrderSources = (callback) ->
    $.ajax
      type: 'GET'
      url: '/api/order_sources'
      dataType: 'JSON'
      success: (collection) ->
        callback(collection.sources)

  changeSourcesList = (sourcesList) ->
    options = createOptionsCollection(sourcesList)
    element = $('#order_order_source_id')
    element.find('option').remove()
    element.append(options)

  createOptionsCollection = (objects) ->
    options = []
    $.each(objects, (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.value + '</option>'


  # == Events ===

  $('.source_updater').on('click', (event) ->
    event.preventDefault()
    loadOrderSources((collection) ->
      changeSourcesList(collection)
    )
  )
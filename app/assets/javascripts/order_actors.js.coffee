$(document).ready ->

  getOrderId = ->
    matches = $('form#order_form').prop('action').match(/admin\/orders\/(\d+)/)
    if matches
      return matches[1]
    else
     return null

  getPositionStart = (container) ->
    time = moment($(container).find('.position_start_time').prop('value'), 'hh:mm')
    addPerformanceDateToTime(time)

  getPositionStop = (container) ->
    time = moment($(container).find('.position_stop_time').prop('value'), 'hh:mm')
    addPerformanceDateToTime(time)

  addPerformanceDateToTime = (time) ->
    date = moment($('#order_performance_date').prop('value'), "DD-MM-YYYY")
    date.set({hours: time.hour(), minutes: time.minute()})
    date

  getPositionId = (container) ->
    $(container).data('objectId')

  getParams = (container) ->
    characterID = $(container).find('.character_id_hidden').prop('value')
    {
      character_id: characterID,
      start: getPositionStart(container).format(),
      stop: getPositionStop(container).format(),
      order_id: getOrderId(),
      id: getPositionId(container)
    }

  getPositionIndex = (container) ->
    name = $(container).find('.position_start_time').prop('name')
    matches = name.match(/order\[positions\]\[(\d+)\]\[start\]/)
    if matches
      return matches[1]
    else
      return null

  loadActorsTable = (container) ->
    box = container
    $.ajax
      type: 'POST',
      url: '/api/actors/time_table'
      data: {
        order_id: getOrderId(),
        index: getPositionIndex(),
        position: getParams(box)
      }
      success: (data) ->
        $(box).find('.actor_row').remove()
        $(box).append(data.template)
        markAllActorsOccupied(box, data.free_actors == 0)

  markAllActorsOccupied = (container, value) ->
    if value
      container.find('.actor_occupation').addClass('occupied')
      container.find('.actor_occupation').find('.glyphicon').attr('class', 'glyphicon glyphicon-remove-circle')
    else
      container.find('.actor_occupation').removeClass('occupied')
      container.find('.actor_occupation').find('.glyphicon').attr('class', 'glyphicon glyphicon-ok-sign')

  # time in time pickers updates by chain from main time
  # picker or manualy by user
  $('.time_picker').on('dp.change', (event) ->
    container = $(this).parents('.order_object')
    loadActorsTable(container)
  )
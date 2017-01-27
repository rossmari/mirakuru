$(document).ready ->
  selectedHours = {}

  initializeCalendar = ->
    $('#calendar').datetimepicker({
      inline: true,
      sideBySide: false,
      locale: 'ru',
      format: 'DD.MM.YYYY'
    })

  selectHour = (hour) ->
    selectedHours[hour] = !selectedHours[hour]
    console.log(selectedHours)

  updateHourBlockStyles = (element) ->
    hour = element.data('hour')
    if selectedHours[hour]
      element.addClass('selected')
    else
      element.removeClass('selected')

  $('.hour_selector').on('click', (event) ->
    hour = $(this).data('hour')
    selectHour(hour)

    updateHourBlockStyles($(this))
  )


  initializeCalendar()

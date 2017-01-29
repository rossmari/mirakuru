$(document).ready ->
  selectedHours = {}
  charactersCollection = {}
  charactersBlocks = {}

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

  loadCharacters = (model, instanceId, callback) ->
    $.ajax
      type: "GET",
      url: '/api/' + model  + '/' + instanceId,
      success: (data) ->
        charactersCollection = data
        callback()

  loadCharactersContainers = (ids, callback) ->
    $.ajax
      type: "POST",
      url: '/api/characters/partner_container',
      data: {ids: ids}
      success: (data) ->
        charactersBlocks = data.containers
        callback()

  redrawCharactersBlocks = ->
    $('.characters_list').empty()
    $.each(Object.keys(charactersBlocks), (index, key) ->
      $('.characters_list').append(charactersBlocks[key])
    )

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.name + '</option>'

  updateCharactersSelectorOptions = ->
    options = createOptionsCollection(charactersCollection)
    element = $('#characters_selector')
    element.find('option').remove()
    element.append(options)

  createOptionsCollection = (objects) ->
    options = ['<option value="">Не выбрано</option>']
    $.each(objects, (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  charactersIds = ->
    ids = []
    $.each(charactersCollection, (index, element) ->
      ids.push(element.id)
    )
    ids

  # === Events
  # hours select boxes
  $('.hour_selector').on('click', (event) ->
    hour = $(this).data('hour')
    selectHour(hour)

    updateHourBlockStyles($(this))
  )

  # order object select and characters ajax load
  $('#objects_selector').on('change', (event) ->
    objectDescription = $(this).val()
    matches = objectDescription.match(/(\S+)_(\d+)/)
    if matches
      model = matches[1]
      instanceId = matches[2]
      loadCharacters(model, instanceId, () ->
        updateCharactersSelectorOptions()
        loadCharactersContainers(charactersIds(), redrawCharactersBlocks)
      )
  )

  $('#characters_selector').on('change', (event) ->
    characterId = $(this).val()
    $('.characters_list').empty()
    $('.characters_list').append(charactersBlocks[characterId])
  )

  # === Initial state
  initializeCalendar()

$(document).ready ->
  orderObjects = {}
  selectedValues = {}
  charactersCollection = {}
  selectorIdCounter = 0
  objectIndexCounter = 0

  addObject = (element) ->
    container = element.closest('.order_object_container')
    selectorIdCounter = selectorIdCounter + 1
    $(objectSelectTemplate(selectorIdCounter)).insertAfter($(container).closest('.order_object_container'))

  copyStartTime = (element) ->
    time = $('#order_performance_time').prop('value')
    inputName = element.data('inputName')
    $('input[name="' + inputName + '"]').prop('value', time)

  copyStopTime = (element) ->
    time = moment('2016-01-01 ' + $('#order_performance_time').prop('value'))
    duration = $('#order_performance_duration').prop('value')
    newTime = time.add(duration, 'minutes').format('LT')
    inputName = element.data('inputName')
    $('input[name="' + inputName + '"]').prop('value', newTime)

  objectSelectTemplate = (selectorIndex) ->

    '<div id="order_object_container_' + selectorIndex + '" class="container-fluid order_object_container order_row">' +
      '<div class="row">' +
        '<div class="col-md-2">' +
          '<select name="order_object_selector" id="order_object_selector' + selectorIndex + '" class="form-control input-sm order_object_selector" data-object-index="' + selectorIndex + '">' +
          availableOptions() +
          '</select>' +
        '</div>' +
        '<div class="col-md-2 action_link">' +
          '<a class="add_order_object" href="#" style="display:none" title="Добавить персонаж/программу">' +
            '<span class="glyphicon glyphicon-plus" />' +
          '</a>' +
          '<a class="remove_order_object" href="#" style="display:none" title="Исключить персонаж/программу">' +
            '<span class="glyphicon glyphicon-trash" />' +
          '</a>' +
        '</div>' +
      '</div>' +
    '</div>'

  availableOptions = ->
    options = ['<option value="">Не выбрано</option>']
    $.each(availableObjects(), (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.name + '</option>'

  synchronizeSelectorsOptions = ->
    $.each($('.order_object_selector'), (index, element) ->
      value = $(element).prop('value')
      synchronizeSelectorOptions($(element))
      $(element).val(value)
    )

  synchronizeSelectorOptions = (element) ->
    value = element.prop('value')
    return if value == ''
    options = availableOptions()
    options.push(optionFromObject(orderObjects[value]))
    element.find('option').remove()
    element.append(options)

  characterInvitationTemplate = (indexInList, character) ->
    objectIndexCounter = objectIndexCounter + 1
    # todo : remove
    index = objectIndexCounter
    cssClass =
      if indexInList == 0
        'order_object'
      else
        'order_object top_divider'
    characterName = character.name

    '<div data-object-id=' + character.id + '" class="' + cssClass + '">' +
      '<div class="row">' +
        '<div class="col-md-3 header">' +
          characterName +
        '</div>' +
      '</div>' +
      '<div class="row header_row">' +
        '<div class="col-md-1">время начала</div>' +
        '<div class="col-md-1 action_link">' +
          '<a href="#" class="start_as_in_order" data-input-name="order[characters][' + index + '][start]">как в заказе</a>' +
        '</div>' +
        '<div class="col-md-1">время окончания</div>' +
        '<div class="col-md-1 action_link">' +
          '<a href="#" class="stop_as_in_order" data-input-name="order[characters][' + index + '][stop]">как в заказе</a>' +
        '</div>' +
      '</div>' +
      '<div class="row order_row">' +
        '<div class="col-md-2">' +
          '<div class="input-group date time_picker">' +
            '<input name="order[characters][' + index + '][start]" class="form-control input-sm" />' +
            '<span class="input-group-addon"><span class="glyphicon glyphicon-time" /></span>' +
          '</div>' +
        '</div>' +
        '<div class="col-md-2">' +
          '<div class="input-group date time_picker">' +
            '<input name="order[characters][' + index + '][stop]" class="form-control input-sm" />' +
            '<span class="input-group-addon"><span class="glyphicon glyphicon-time" /></span>' +
          '</div>' +
        '</div>' +
      '</div>' +
    '</div>' +
    '<input name="order[characters][' + index + '][id]" class="form-control input-sm" type="hidden" value="character.id">' +
    '<input name="order[characters][' + index + '][owner_class]" class="form-control input-sm" type="hidden" value="@object.class">' +
    '<input name="order[characters][' + index + '][owner_id]" class="form-control input-sm" type="hidden" value="@object.id">'

  showAllDeleteButtons = ->
    $.each($('.remove_order_object'), (index, element) ->
      $(element).show();
    )

  hideAllAddButtons = ->
    $.each($('.add_order_object'), (index, element) ->
      $(element).hide()
    )

  showLastAddButton = ->
    $('.add_order_object').last().show()

  hideLastDeleteButton = ->
    $('.remove_order_object').last().hide()

  startTimePickers = ->
    $('.time_picker').datetimepicker({locale: 'ru', format: 'LT'})

  startDatePickers = ->
    $('.date_picker').datetimepicker({
      locale: 'ru',
      format: 'DD.MM.YYYY',
    })

  preloadOrderObjects = ->
    $.ajax
      type: 'GET'
      url: '/api/order_objects'
      format: 'JSON'
      success: (data) ->
        orderObjects = data.objects
        console.log('Preload orders objects list ---')
        console.log(orderObjects)

  preloadCharacters = ->
    $.ajax
      type: 'GET'
      url: '/api/characters'
      format: 'JSON'
      success: (data) ->
        $.map(data.characters, (element) ->
          charactersCollection[element.id] = element
        )
        console.log('Preload characters list ---')
        console.log(charactersCollection)

  loadStage = (element, callback) ->
    stageId = element.prop('value');
    $.ajax
      type: "GET",
      url: '/api/stages/' + stageId,
      success: (data) ->
        callback(data)

  loadParther = (element, callback) ->
    partnerId = element.prop('value')
    $.ajax
      type: 'GET'
      url: '/api/partners/' + partnerId
      success: (data) ->
        callback(data)

  activateSearchSelectors = ->
    $('.order_object_selector').select2({theme: "bootstrap"})

  markSelectedOrderObjects = (value, objectId) ->
    objectClass = orderObjects[objectId].class
    characters = orderObjects[objectId].characters
    $.each(characters, (index, character) ->
      $.each(orderObjects, (index, orderObject) ->
        if $.inArray(character, orderObject.characters) > -1
          orderObjects[orderObject.id].available = value
          console.log('Update Availability: ' + orderObject.id + ', set to: ' + value)
      )
    )

  setSelectedValue = (value, selectorId) ->
    selectedValues[selectorId] = value

  removeSelectorWithObjects = (element) ->
    container = $(this).closest('.order_object_container');
    selector = element.parents('.order_object_container').find('.order_object_selector')
    newObjectId = $(selector).prop('value')
    selectorId = $(selector).prop('id')
    previousObjectId = selectedValues[selectorId]

    if previousObjectId
      markSelectedOrderObjects(true, previousObjectId)

    container = element.closest('.order_object_container')
    container.hide()
    updateControlButtonsState()

  availableObjectsCount = ->
    availableObjects().length

  availableObjects = ->
    objects = []
    $.each(orderObjects, (key, value) ->
      if orderObjects[key].available
        objects.push(value)
    )
    objects

  availableSelectBoxes = ->
    $.grep($('.order_object_selector'), (index, element) ->
      $(element).prop('value') == ''
    ).length

  updateControlButtonsState = ->
    availbleObjCount = availableObjectsCount()
    selectorsCount = $('.order_object_selector').length
    availableSelectors = availableSelectBoxes()

    console.log 'Available. Objects: ' + availbleObjCount + ', selectors: ' + availableSelectors

    if availbleObjCount > 1
      showAllDeleteButtons()
      hideAllAddButtons()
      showLastAddButton()
    else if availbleObjCount == 1 and availableSelectors == 1
      showAllDeleteButtons()
      hideAllAddButtons()
    else if availbleObjCount == 1 and availableSelectors == 0
      showAllDeleteButtons()
      # hideLastDeleteButton();
      hideAllAddButtons()
      showLastAddButton()
    else
      hideAllAddButtons()
      showAllDeleteButtons()
    if selectorsCount == 1
      hideLastDeleteButton()

  readPageInitialState = ->
    # TODO : load page in Edit mode

  # ======================= events
  # after we select value in order objects selector
  $(document).on 'change', '.order_object_selector', (event) ->
    newObjectId = $(this).prop('value')
    selectorId = $(this).prop('id')
    console.log('Update selector with id: ' + selectorId)
    container = $(this).closest('.order_object_container');

    previousObjectId = selectedValues[selectorId]
    if previousObjectId
      markSelectedOrderObjects(true, previousObjectId)

    # if new value blank
    if newObjectId == ''
      # TODO: do we need this branch ?
    else
      markSelectedOrderObjects(false, newObjectId)
      $(container).find('.order_object').remove();
      $.each(orderObjects[newObjectId].characters, (index, characterId) ->
        $(container).append(characterInvitationTemplate(index, charactersCollection[characterId]))
      )
      startTimePickers();

    setSelectedValue(newObjectId, selectorId)
    updateControlButtonsState()
    synchronizeSelectorsOptions()

  # copy Start and Stop time from global picker to characters pickers
  $(document).on('click', '.start_as_in_order', (event) ->
    event.preventDefault();
    copyStartTime($(this))
  )
  # copy Start and Stop time from global picker to characters pickers
  $(document).on('click', '.stop_as_in_order', (event) ->
    event.preventDefault();
    copyStopTime($(this))
  )
  # set duration from pre defined templates
  $('.fast_duration').on('click', (event) ->
    event.preventDefault();
    value = $(event.currentTarget).data('value');
    $('#order_performance_duration').prop('value', value)
  )
  # add new selector, to select objects (performances or characters)
  $(document).on('click', '.add_order_object', (event) ->
    event.preventDefault()
    addObject($(this))
    updateControlButtonsState()
    synchronizeSelectorsOptions()
  )
  # remove selector and selected objects
  $(document).on('click', '.remove_order_object', (event) ->
    event.preventDefault();
    removeSelectorWithObjects($(this))
    synchronizeSelectorsOptions()
    activateSearchSelectors()
    updateControlButtonsState()
  )
  # select stage (ajax load)
  $('#stages_selector').on('change', (event) ->
    loadStage($(this), (data) ->
      $('#order_street').prop('value', data.street)
      $('#order_house').prop('value', data.house)
    )
  )
  # select partner (load stage by Ajax, auto fill fields)
  $('#partners_selector').on('change', (event) ->
    loadParther($(this), (data) ->
      $('#stages_selector').val(data.stage_id)
      $('#stages_selector').trigger('change')
      $('#order_contact_name').prop('value', data.contact_name)
      $('#order_contact_phone').prop('value', data.contact_phone)
    )
  )

  # ======================= Initial State
  preloadOrderObjects()
  activateSearchSelectors()
  startTimePickers()
  preloadCharacters()
  startDatePickers()

  readPageInitialState()

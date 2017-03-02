$(document).ready ->
  orderObjects = {}
  selectedValues = {}
  charactersCollection = {}
  stagesCollection = {}
  selectorIdCounter = 1
  objectIndexCounter = 0
  actorsList = {}
  performanceStart = null
  performanceStop = null

  markOccupiedCostumes = ->
    # Bad way , need to update some how (soft udpdate)
    $.each($('.order_object_selector'), (index, element) ->
      objectKey = $(element).prop('value')
      orderObject = orderObjects[objectKey]
      container = getObjectContainer(objectKey)
      if orderObject && orderObject.occupied
        container.find('.costume_occupation').addClass('occupied')
        container.find('.costume_occupation').find('.glyphicon').attr('class', 'glyphicon glyphicon-remove-circle')
      else
        container.find('.costume_occupation').removeClass('occupied')
        container.find('.costume_occupation').find('.glyphicon').attr('class', 'glyphicon glyphicon-ok-sign')
    )

  getOrderId = ->
    matches = $('form#order_form').prop('action').match(/admin\/orders\/(\d+)/)
    if matches
      return matches[1]
    else
      return null

  markOccupiedCharacters = ->
    objectIds = Object.keys(orderObjects)
    orderId = getOrderId()

    $.each(objectIds, (index, objectId) ->
      characterIds = orderObjects[objectId].characters

      start = getObjectStart(objectId).add(-60, 'minutes')
      stop  = getObjectStop(objectId).add(60, 'minutes')

      $.each(characterIds, (index, characterId) ->
        invitations = charactersCollection[characterId].invitations
        if invitations && invitations.length > 0
          $.map(invitations, (invitation) ->
            # x - invitation
            # (x.first - y.end) * (y.first - x.end) >= 0
            # if we change/edit order - that we should skeep invitations from this order

            if orderId
              if (moment(invitation.start) - stop) * (start - moment(invitation.stop)) >= 0 && invitation.order_id != parseInt(orderId)
                orderObjects[objectId]['occupied'] = true
              else
                orderObjects[objectId]['occupied'] = false
            else
              if (moment(invitation.start) - stop) * (start - moment(invitation.stop)) >= 0
                orderObjects[objectId]['occupied'] = true
              else
                orderObjects[objectId]['occupied'] = false
          )
      )
    )
    count = 0
    $.each(objectIds, (index, objectId) ->
      if !orderObjects[objectId].occupied
        count = count + 1
    )
    synchronizeSelectorsOptions()
    markOccupiedCostumes()
    $('#available_characters_count').text('Доступно объектов: ' + count)

  #
  # get order object start time if its selected
  getObjectStart = (objectId) ->
    startTime = moment(getObjectInputs(objectId).first().prop('value'), 'hh:mm')
    addPerformanceDateToTime(startTime )

  #
  # get order object stop time if its selected
  getObjectStop = (objectId) ->
    stopTime = moment(getObjectInputs(objectId).last().prop('value'), 'hh:mm')
    addPerformanceDateToTime(stopTime)

  getObjectInputs = (objectId) ->
    getObjectContainer(objectId).find('.time_picker').find('input')

  getObjectContainer = (objectId) ->
    $('.order_object_selector [value="' + objectId + '"]').parents('.order_object_container')

  getPerformanceStart = ->
    time = moment($('#order_performance_time').prop('value'),  'hh:mm')
    addPerformanceDateToTime(time)

  getPerformanceStop = ->
    duration = $('#order_performance_duration').val()
    date = getPerformanceStart()
    date.add(duration, 'minutes')
    date

  addPerformanceDateToTime = (time) ->
    date = moment($('#order_performance_date').prop('value'), "DD-MM-YYYY")
    date.set({hours: time.hour(), minutes: time.minute()})
    date

  isCharacterOcupied = (character) ->
    characterStop = moment(character.stop).add(60, 'F')
    characterStart = moment(character.start).add(-60, 'minutes')
    (characterStart - performanceStop) * (performanceStart - characterStop) >= 0

  isActorCloseToOccupied = (position) ->
    positionStop = moment(position.stop).add(60, 'F')
    positionStart = moment(position.start).add(-60, 'minutes')
    # x - positionStart / positionStop
    # y - performanceStart / performanceStop
    # (x.first - y.end) * (y.first - x.end) >= 0
    (positionStart - performanceStop) * (performanceStart - positionStop) >= 0


  isActorOccupied = (position) ->
    positionStop = moment(position.stop)
    positionStart = moment(position.start)
    (positionStart - performanceStop) * (performanceStart - positionStop) >= 0

  prepareActorsCheckBoxes = (characterIndex, characterId) ->
    htmlBlocks = $.map(actorsList, (actor, actorIndex) ->
      extraSettings = ''
      spanClass = ''
      baseName = 'order[positions][' + characterIndex + '][actors][' + actor.id + ']'
      isActorAvailable = $.inArray(characterId, actor.characters) > -1

      if actor.invitations.length > 0
        $.each(actor.invitations, (index, invitation) ->
          if isActorOccupied(invitation)
            spanClass = 'occupied'
            return true
          if isActorCloseToOccupied(invitation)
            spanClass = 'almost_occupied'
        )

      if !isActorAvailable
        extraSettings = extraSettings + ' disabled="true"'
        spanClass = ' disabled'

      '<div class="col-md-2 actor_name">' +
        '<input type="checkbox" value="1" name="' + baseName + '[checked]"' + extraSettings + '/>' +
        '<span class="actor_name ' + spanClass + '">' + actor.name + '</span>' +
      '</div>' +
      '<div class="col-md-1 actor_corrector">' +
        '<input title="Корректор" class="form-control input-sm" value="0.0" name="' + baseName + '[corrector]"' + extraSettings + '/>' +
      '</div>'
    )
    rows = ''
    while(htmlBlocks.length > 0)
      row =
        '<div class="row order_row actor_row">' +
          htmlBlocks.splice(0, 3).join(' ') +
        '</div>'
      rows = rows + row
    rows

  addObject = (element) ->
    container = element.closest('.order_object_container')
    selectorIdCounter = selectorIdCounter + 1
    $(objectSelectTemplate(selectorIdCounter)).insertAfter($(container).closest('.order_object_container'))

  copyStartTime = (input) ->
    $(input).prop('value', performanceStart.format('LT'))
    $(input).trigger('dp.change')

  copyStopTime = (input) ->
    $(input).prop('value', performanceStop.format('LT'))
    $(input).trigger('dp.change')

  objectSelectTemplate = (selectorIndex) ->

    '<div class="container-fluid order_object_container order_row" id="order_object_container_' + selectorIndex + '">' +
      '<div class="row">' +
        '<div class="col-md-2 error_container">' +
          '<select name="order_object_selector" id="order_object_selector' + selectorIndex + '" class="form-control input-sm order_object_selector" data-object-index="' + selectorIndex + '">' +
            availableOptions() +
          '</select>' +
          '<div name="order[positions]/>' +
          '<div class="error_message actors_error" />' +
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
    options = []
    options.push(emptyOption())
    $.each(availableObjects(), (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  emptyOption = ->
    '<option value="">Не выбрано</option>'

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
    options = availableOptions()

    if value != ''
      options.push(optionFromObject(orderObjects[value]))
    element.find('option').remove()
    element.append(options)

  characterPositionTemplate = (indexInList, character, ownerObject) ->
    objectIndexCounter = objectIndexCounter + 1
    # todo : remove
    index = objectIndexCounter
    cssClass =
      if indexInList == 0
        'order_object'
      else
        'order_object top_divider'
    characterName = character.name
    actorsCheckBoxes = prepareActorsCheckBoxes(index, character.id)
    ownerClass = ownerObject.class
    ownerId = ownerObject.instance_id

    '<div data-object-id=' + character.id + '" class="' + cssClass + '">' +
      '<div class="row">' +
        '<div class="special_head_row header">' +
          characterName +
        '</div>' +
        '<div class="sub_header first costume_occupation">' +
          '<span>костюм </span>' +
          '<span class="glyphicon glyphicon-ok-sign" />' +
        '</div>' +
        '<div class="sub_header actor_occupation">' +
          '<span>аниматор </span>' +
          '<span class="glyphicon glyphicon-ok-sign" />' +
        '</div>' +
      '</div>' +
      '<div class="row header_row">' +
        '<div class="col-md-1">время начала</div>' +
        '<div class="col-md-1 action_link">' +
          '<input type="checkbox" value="1" name="order[positions][' + index + '][fixed_start]" class="fixed_position_start"> ' +
          '<span>как в заказе</span>' +
        '</div>' +
        '<div class="col-md-1">время окончания</div>' +
        '<div class="col-md-1 action_link">' +
          '<input type="checkbox" value="1" name="order[positions][' + index + '][fixed_stop]" class="fixed_position_stop"> ' +
          '<span>как в заказе</span>' +
        '</div>' +
        '<div class="col-md-1">стоймость</div>' +
          '<div class="col-md-1 action_link">' +
          '<input type="checkbox" value="1" name="order[positions][' + index + '][payed]" id="order_partner_payed"> оплачено' +
        '</div>' +
        '<div class="col-md-1">гонорар актера</div>' +
          '<div class="col-md-1 action_link">' +
            '<input type="checkbox" value="1" name="order[positions][' + index + '][animator_payed]" id="order_animator_payed"> оплачено' +
          '</div>' +
        '<div class="col-md-1">накладные</div>' +
      '</div>' +

      '<div class="row order_row">' +
        '<div class="col-md-2 error_container">' +
          '<div class="input-group date time_picker">' +
            '<input name="order[positions][' + index + '][start]" class="form-control input-sm position_start_time" value="' + moment(performanceStart).format('LT') + '"/>' +
            '<span class="input-group-addon"><span class="glyphicon glyphicon-time" /></span>' +
          '</div>' +
          '<div class="error_message"></div>' +
        '</div>' +
        '<div class="col-md-2 error_container">' +
          '<div class="input-group date time_picker">' +
            '<input name="order[positions][' + index + '][stop]" class="form-control input-sm position_stop_time" value="' + moment(performanceStop).format('LT') + '"/>' +
            '<span class="input-group-addon"><span class="glyphicon glyphicon-time" /></span>' +
          '</div>' +
          '<div class="error_message"></div>' +
        '</div>' +

        '<div class="col-md-2 error_container">' +
          '<div class="input-group input-group-sm">' +
            '<input name="order[positions][' + index + '][price]" value="0" class="form-control input-sm position_price" />' +
            '<span class="input-group-addon" title: "Вставить из прайса" >' +
              '<span class="glyphicon glyphicon-th-list load_from_price" data-attribute="price" />' +
            '</span>' +
          '</div>' +
          '<div class="error_message"></div>' +
        '</div>' +

        '<div class="col-md-2 error_container">' +
          '<div class="input-group input-group-sm">' +
            '<input name="order[positions][' + index + '][animator_money]" value="0" class="form-control input-sm position_animator_money" />' +
            '<span class="input-group-addon" title: "Вставить из прайса" >' +
              '<span class="glyphicon glyphicon-th-list load_from_price" data-attribute="animator_money" />' +
            '</span>' +
          '</div>' +
          '<div class="error_message"></div>' +
        '</div>' +

        '<div class="col-md-2 error_container">' +
          '<input name="order[positions][' + index + '][overheads]" value="0" class="form-control input-sm position_overheads" />' +
          '<div class="error_message"></div>' +
        '</div>' +
      '</div>' +

      '<div class="row header_row">' +
        '<div class="col-md-3">Примечание к заказу</div>' +
        '<div class="col-md-3">Информация для актера</div>' +
      '</div>' +
      '<div class="row order_row">' +
        '<div class="col-md-3">' +
          '<textarea name="order[positions][' + index + '][order_notice]" class="form-control input-sm" />' +
        '</div>' +
        '<div class="col-md-3">' +
          '<textarea name="order[positions][' + index + '][actor_notice]" class="form-control input-sm" />' +
        '</div>' +
      '</div>' +
      '<div class="row order_row">' +
        '<div class="col-md-3 input_header">Назначение актера ' +
          '<span class="header">' +
            characterName +
          '</span>' +
        '</div>' +
      '</div>' +
      '<div class="row order_row">' +
        '<div class="error_container col-md-3">' +
          '<div name="order[positions][' + index + '][actors]"/>' +
          '<div class="error_message actors_error" />' +
        '</div>' +
      '</div>' +
      actorsCheckBoxes +
      '<input name="order[positions][' + index + '][character_id]" class="form-control input-sm character_id_hidden" type="hidden" value="' + character.id + '">' +
      '<input name="order[positions][' + index + '][owner_class]" class="form-control input-sm" type="hidden" value="' + ownerClass + '">' +
      '<input name="order[positions][' + index + '][owner_id]" class="form-control input-sm" type="hidden" value="' + ownerId + '">' +
      '<div class="row separator"></div>' +
    '</div>'


  showAllDeleteButtons = ->
    deleteButtons = visibleContainers().find('.remove_order_object')
    $.each(deleteButtons, (index, button) ->
      $(button).show();
    )

  hideAllAddButtons = ->
    addButtons = visibleContainers().find('.add_order_object')
    $.each(addButtons, (index, button) ->
      $(button).hide()
    )

  showLastAddButton = ->
    addButtons = visibleContainers().find('.add_order_object')
    addButtons.last().show()

  hideLastDeleteButton = ->
    deleteButtons = visibleContainers().find('.remove_order_object')
    deleteButtons.last().hide()

  hideAllDeleteButtons = ->
    deleteButtons = visibleContainers().find('.remove_order_object')
    $.each(deleteButtons, (index, button) ->
      $(button).hide()
    )

  startTimePickers = ->
    $('.time_picker').datetimepicker({
      locale: 'ru',
      format: 'LT'
    }).on('dp.change', (event) ->
      targetId = $(event.currentTarget).find('input').prop('id')
      # update performance start if this is exact input with ID
      if targetId == 'order_performance_time'
        setPerformanceStartAndStop()
        updateFixedPositionTimes(performanceStart, performanceStop)
      # -----------------------
      markOccupiedCharacters()
    )

  startDatePickers = ->
    $('.date_picker').datetimepicker({
      locale: 'ru',
      format: 'DD.MM.YYYY'
    }).on('dp.change', (event) ->
      targetId = $(event.currentTarget).find('input').prop('id')
      # update performance date if this is exact input with ID
      if targetId == 'order_performance_date'
        setPerformanceStartAndStop()
        updateFixedPositionTimes(performanceStart, performanceStop)
      # -----------------------
      markOccupiedCharacters()
    )

  preloadActors = ->
    actorsSerialized = $('#actors_serialized').prop('value')
    actorsList = JSON.parse(actorsSerialized)

  preloadOrderObjects = ->
    objectsSerialized= $('#objects_serialized').prop('value')
    orderObjects = JSON.parse(objectsSerialized)

  preloadCharacters = ->
    charactersSerialized = $('#characters_serialized').prop('value')
    characters = JSON.parse(charactersSerialized)
    $.map(characters, (element) ->
      charactersCollection[element.id] = element
    )

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
    $('#customer_selector').select2({theme: "bootstrap"})
    $('#stages_selector').select2({theme: "bootstrap"})

  markSelectedOrderObjects = (value, objectId) ->
    characters = orderObjects[objectId].characters
    $.map(characters, (character) ->
      $.map(orderObjects, (orderObject) ->
        if $.inArray(character, orderObject.characters) > -1
          orderObjects[orderObject.id].available = value
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
      if orderObjects[key].available && !orderObjects[key].occupied
        objects.push(value)
    )
    objects

  # all order object container , not hidden
  visibleContainers = ->
    $('.order_object_container:visible')

  totalSelectBoxesCount = ->
    selectors = visibleContainers().find('.order_object_selector')
    selectors.length

  emptySelectBoxesCount = ->
    selectors = visibleContainers().find('.order_object_selector')
    $.grep(selectors, (element, index) ->
      $(element).prop('value') == ""
    ).length

  updateControlButtonsState = ->
    totalBoxesCount = totalSelectBoxesCount()
    emptyBoxesCount = emptySelectBoxesCount()
    objectsCount = availableObjectsCount()
    console.log('Available objects count: ' + objectsCount + ' empty selectors: ' + emptyBoxesCount + ' total boxes: ' + totalBoxesCount)

    if totalBoxesCount > 1
      # have more than 1 selector existing
      # this mean we can remove any of them safely
      showAllDeleteButtons()
    else
      # have 0 or 1 selector existing
      # this means we CANT remove this last selector
      hideAllDeleteButtons()

    hideAllAddButtons()
    if emptyBoxesCount < objectsCount
      showLastAddButton()

  activateMasks = ->
    $("#contact_value").mask("+7 (999) 999 99 99");

  readPageInitialState = ->
    # TODO : load page in Edit mode

  setPerformanceStartAndStop = ->
    performanceStart = getPerformanceStart()
    performanceStop = getPerformanceStop()

  # for initial state - set all selected values
  assignSelectedPreviousValues = ->
    $.each($('.order_object_selector'), (index, element) ->
      selectorId = $(element).prop('id')
      selectedValues[selectorId] = $(element).prop('value')
    )

  checkFixedPositonTimes = ->
    $.each($('.fixed_position_start'), (index, element) ->
      if $(element).prop('checked')
        $(element).parents('.order_object').find('.position_start_time').attr('readonly', true)
    )
    $.each($('.fixed_position_stop'), (index, element) ->
      if $(element).prop('checked')
        $(element).parents('.order_object').find('.position_stop_time').attr('readonly', true)
    )

  #
  # After we change main performance time - all positions with fixed time should be changed
  #
  updateFixedPositionTimes = (start, stop) ->
    $.each($('.fixed_position_start'), (index, element) ->
      if $(element).prop('checked')
        input = $(element).parents('.order_object').find('.position_start_time')
        copyStartTime(input)
    )
    $.each($('.fixed_position_stop'), (index, element) ->
      if $(element).prop('checked')
        input = $(element).parents('.order_object').find('.position_stop_time')
        copyStopTime(input)
  )
  # ======================= events
  # after we select value in order objects selector
  $(document).on 'change', '.order_object_selector', (event) ->
    newObjectId = $(this).prop('value')
    selectorId = $(this).prop('id')
    container = $(this).closest('.order_object_container');

    previousObjectId = selectedValues[selectorId]
    if previousObjectId
      markSelectedOrderObjects(true, previousObjectId)

    # if new value blank
    if newObjectId == ''
      $(container).find('.order_object').remove();
      if previousObjectId != ''
        markSelectedOrderObjects(true, previousObjectId)
    else
      # change availability of new object to false
      markSelectedOrderObjects(false, newObjectId)
      $(container).find('.order_object').remove();
      $.each(orderObjects[newObjectId].characters, (index, characterId) ->
        $(container).append(characterPositionTemplate(index, charactersCollection[characterId], orderObjects[newObjectId]))
      )
      startTimePickers();

    setSelectedValue(newObjectId, selectorId)
    updateControlButtonsState()
    synchronizeSelectorsOptions()

  # set duration from pre defined templates
  $('.fast_duration').on('click', (event) ->
    event.preventDefault();
    value = $(event.currentTarget).data('value');
    $('#order_performance_duration').val(value)
    $('#order_performance_duration').trigger('change')
  )
  # add new selector, to select objects (performances or characters)
  $(document).on('click', '.add_order_object', (event) ->
    event.preventDefault()
    addObject($(this))
    updateControlButtonsState()
    synchronizeSelectorsOptions()
    activateSearchSelectors()
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
  # change start, stop when duration is changed
  $('#order_performance_duration').on('change', (event) ->
    setPerformanceStartAndStop()
    updateFixedPositionTimes(performanceStart, performanceStop)
    markOccupiedCharacters()
  )

  #
  # when we check "Time as in order" - change time in input and set read only
  $(document).on('change', '.fixed_position_stop', (event) ->
    input =  $(this).parents('.order_object').find('.position_stop_time')
    if $(this).prop('checked')
      copyStopTime(input)
    input.prop('readonly', $(this).prop('checked'))
  )

  $(document).on('change', '.fixed_position_start', (event) ->
    input =  $(this).parents('.order_object').find('.position_start_time')
    if $(this).prop('checked')
      copyStartTime(input)
    input.prop('readonly', $(this).prop('checked'))
  )
  # ======================= Initial State
  preloadOrderObjects()
  activateSearchSelectors()
  startTimePickers()
  preloadCharacters()
  preloadActors()
  startDatePickers()
  activateMasks()

  # mark previously saved characters as 'not available'
  $.each($('.order_object_selector'), (index, element) ->
    objectId = $(element).prop('value')
    if objectId != ''
      markSelectedOrderObjects(false, objectId)
  )
  synchronizeSelectorsOptions()
  # first set time params of order
  setPerformanceStartAndStop()
  # then find which object is occupied for this time
  markOccupiedCharacters()
  # ----------------------------------------------------
  updateControlButtonsState()
  assignSelectedPreviousValues()

  checkFixedPositonTimes()

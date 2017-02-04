$(document).ready ->
  stagesCollection = {}

  preloadStages = ->
    stagesSerialized = $('#stages_serialized').prop('value')
    stagesCollection = JSON.parse(stagesSerialized)

  updateStageSwitchButtons = (button) ->
    $('.stage_switcher').prop('class', 'stage_switcher btn btn-default')
    button.prop('class', 'stage_switcher btn btn-primary')

  updateStageInputs = (stageType) ->
    if stageType == 0 || stageType == 2
      $('.stage_inputs').find('input').prop('disabled', true)
      $('.stage_inputs').find('select').prop('disabled', true)
      $('#stages_selector').prop('disabled', false)
    else
      $('.stage_inputs').find('input').prop('disabled', false)
      $('.stage_inputs').find('select').prop('disabled', false)
      $('#stages_selector').prop('disabled', true)

    if stageType == 2
      customerId = $('#order_customer_id').prop('value')
      if customerId
        changeStagesList(customerId)

  customerStages = (customerId) ->
    $.grep(stagesCollection, (element, index) ->
      $.inArray(parseInt(customerId), element.customers) > -1
    )

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.name + '</option>'

  changeStagesList = (customerId) ->
    stages = customerStages(customerId)
    options = createOptionsCollection(stages)
    element = $('#stages_selector')
    element.find('option').remove()
    element.append(options)

  createOptionsCollection = (objects) ->
    options = ['<option value="">Не выбрано</option>']
    $.each(objects, (index, object) ->
      options.push(optionFromObject(object))
    )
    options

  updateStageTypeValue = (stageType) ->
    $('#stage_mode').prop('value', stageType)

  # ============= events
  # change stage selection type
  $('.stage_switcher').on('click', (event)->
    event.preventDefault()
    updateStageSwitchButtons($(this))
    updateStageInputs($(this).data('value'))
    updateStageTypeValue($(this).data('value'))
  )

  # ============= Initial state
  updateStageInputs(parseInt($('#stage_mode').prop('value')))
  preloadStages()
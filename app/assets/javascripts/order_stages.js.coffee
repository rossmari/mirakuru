$(document).ready ->
  stagesCollection = {}

  loadStagesFromServer = (callback) ->
    $.ajax
      type: "GET",
      url: '/api/stages/',
      success: (data) ->
        callback(data.stages)

  preloadStages = ->
    stagesSerialized = $('#stages_serialized').prop('value')
    stagesCollection = JSON.parse(stagesSerialized)

  updateStageSwitchButtons = (button) ->
    $('.stage_switcher').prop('class', 'stage_switcher btn btn-default')
    button.prop('class', 'stage_switcher btn btn-primary')

  updateStageInputs = (stageType) ->
    if stageType == 0
      $('.stage_constructors').show()
    else
      $('.stage_constructors').hide()

    if stageType == 0 || stageType == 2
      $('.stage_inputs').find('input').prop('disabled', true)
      $('.stage_inputs').find('select').prop('disabled', true)
      $('#stages_selector').prop('disabled', false)
    else
      $('.stage_inputs').find('input').prop('disabled', false)
      $('.stage_inputs').find('select').prop('disabled', false)
      $('#stages_selector').prop('disabled', true)

    if stageType == 2
      customerId = $('#customer_selector').prop('value')
      if customerId
        changeStagesList(customerId)

  customerStages = (customerId) ->
    $.grep(stagesCollection, (element, index) ->
      $.inArray(parseInt(customerId), element.customers) > -1
    )

  optionFromObject = (object) ->
    '<option value="' + object.id + '">' + object.name + '</option>'

  changeStagesList = (customerId) ->
    console.log('Change stages list for: ' + customerId)
    stages = customerStages(customerId)
    changeStagesInputOptions(stages)

  changeStagesInputOptions = (stages) ->
    options = createOptionsCollection(stages)
    element = $('#stages_selector')
    element.find('option').remove()
    element.append(options)
    # select by default first stage (to show that customer has his own stages)
    # if user has any stages
    if stages.length > 0
      element.val(stages[0].id)

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
  $('#customer_selector').on('change', (event) ->
    console.log('Update stage inputs')
    value = $('.stage_switcher').data('value')
    console.log('Switcher value: ' + value)
    updateStageInputs($('.stage_switcher.btn.btn-primary').data('value'))
  )
  $('.stage_updater').on('click', (event) ->
    event.preventDefault()
    loadStagesFromServer( (stages) ->
      console.log(stages)
      changeStagesInputOptions(stages)
    )
  )
  # ============= Initial state
  updateStageInputs(parseInt($('#stage_mode').prop('value')))
  preloadStages()
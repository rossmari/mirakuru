$(document).ready ->
  stagesList = {}

  updateStageSwitchButtons = (button) ->
    $('.stage_switcher').prop('class', 'stage_switcher btn btn-default')
    button.prop('class', 'stage_switcher btn btn-primary')

  updateStageInputs = (stageType) ->
    if stageType == 0
      $('.stage_inputs').find('input').prop('disabled', true)
      $('.stage_inputs').find('select').prop('disabled', true)
      $('#stages_selector').prop('disabled', false)
    else
      $('.stage_inputs').find('input').prop('disabled', false)
      $('.stage_inputs').find('select').prop('disabled', false)
      $('#stages_selector').prop('disabled', true)

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
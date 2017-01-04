$(document).ready(function () {

  $('.updater').on('click', function(event){
    event.preventDefault();

    var name = $(event.currentTarget).data('name');
    var url = '/api/' + name;
    var selector = $('#' + name + '_selector');
    $(selector).empty();

    $.ajax({
      type: "GET",
      url: url,
      success: function(data) {
        $.each(data[name], function(index, element) {
          var option = document.createElement('option');
          option.text = element.name;
          option.value = element.id;
          selector.get(0).add(option, null);
        })
      }
    });
  });

  $('#stages_selector').on('change', function (event) {
    var stageId = $(this).prop('value');
    $.ajax({
      type: "GET",
      url: '/api/stages/' + stageId,
      success: function(data) {
        $('#order_street').prop('value', data.street);
        $('#order_house').prop('value', data.house);
      }
    });
  })

  $('#partners_selector').on('change', function (event) {
    var partnerId = $(this).prop('value');
    $.ajax({
      type: "GET",
      url: '/api/partners/' + partnerId,
      success: function(data) {
        $('#stages_selector').val(data.stage_id);
        $('#stages_selector').trigger('change');
        $('#order_contact_name').prop('value', data.contact_name)
        $('#order_contact_phone').prop('value', data.contact_phone)
      }
    });
  })

  function startDatePickers() {
    $('.date_picker').datetimepicker({
      locale: 'ru',
      format: 'DD.MM.YYYY',
    });
  }

  function startTimePickers() {
    $('.time_picker').datetimepicker({
      locale: 'ru',
      format: 'LT'
    });
  }

  $('.fast_duration').on('click', function (event) {
    event.preventDefault();
    var value = $(event.currentTarget).data('value');
    $('#order_performance_duration').prop('value', value);
  });

  $(document).on('change', '.order_object_selector', function(event) {
    event.preventDefault();
    var container = $(this).closest('.order_object_container');
    var value = $(this).prop('value');

    if(value == '') {
      $(container).find('.order_object').remove();
      availableCharacters(function (count) {
        updateOrderControlButtons(characters, count - 1);
      });
      return
    }

    var index = 1;
    // all selected characters
    var characters = selectedCharacters();
    $.ajax({
      type: "POST",
      url: '/api/order_objects/object_container',
      data: {
        id: value,
        object_index: index,
        selected_characters: characters
      },
      format: 'JSON',
      success: function(data) {
        $(container).find('.order_object').remove();
        $(container).append(data.container);
        startTimePickers();
        updateOrderControlButtons(data.characters_left);
      }
    });
  });

  function updateOrderControlButtons(ordersCount){
    var availableSelectors = 0;
    var selectorsCount = $('.order_object_selector').length;
    $.each($('.order_object_selector'), function (index, element) {
      if ($(element).prop('value') == "") {
        availableSelectors = availableSelectors + 1;
      }
    });
    console.log('Orders: ' + ordersCount + ', Selectors: ' + availableSelectors);
    if(ordersCount > 1) {
      showAllDeleteButtons();
      // hideLastDeleteButton();

      hideAllAddButtons();
      showLastAddButton();
    }
    else if(ordersCount == 1 && availableSelectors == 1){
      showAllDeleteButtons();
      hideAllAddButtons();
    }
    // has one order available but 0 available selectors, need to provide
    // add button
    else if(ordersCount == 1 && availableSelectors == 0) {
      showAllDeleteButtons();
      // hideLastDeleteButton();

      hideAllAddButtons();
      showLastAddButton();
    }
    else {
      hideAllAddButtons();
      showAllDeleteButtons();
    }
    if(selectorsCount == 1){
      hideLastDeleteButton();
    }
  }

  function availableCharacters(callback) {
    $.ajax({
      type: "POST",
      url: '/api/characters/available',
      data: {
        selected_characters: selectedCharacters()
      },
      format: 'JSON',
      success: function(data) {
        callback(data.characters, data.count)
      }
    });
  }

  function hideAllAddButtons()
  {
    $.each($('.add_order_object'), function (index, element) {
      $(element).hide();
    });
  }
  function showLastAddButton() {
    $('.add_order_object').last().show();
  }

  function showAllDeleteButtons(){
    $.each($('.remove_order_object'), function (index, element) {
      $(element).show();
    });
  }

  function hideLastDeleteButton(){
    $('.remove_order_object').last().hide();
  }

  $(document).on('click', '.start_as_in_order', function (event) {
    event.preventDefault();
    var time = $('#order_performance_time').prop('value');
    var inputName = $(this).data('inputName');
    $('input[name="' + inputName + '"]').prop('value', time);
  });

  $(document).on('click', '.stop_as_in_order', function (event) {
    event.preventDefault();
    var time = moment('2016-01-01 ' + $('#order_performance_time').prop('value'));
    var duration = 60;
    var newTime = time.add(duration, 'minutes').format('LT');
    var inputName = $(this).data('inputName');
    $('input[name="' + inputName + '"]').prop('value', newTime);
  });

  $(document).on('click', '.add_order_object', function(event){
    event.preventDefault();
    var container = $(this).closest('.order_object_container');

    // need ?
    // var selectorsCount = $('.order_object_selector').length;
    $.ajax({
      type: "POST",
      url: '/api/order_objects/selector',
      data: {
        selected_characters: selectedCharacters()
        // selectors_count: selectorsCount
      },
      format: 'JSON',
      success: function(data) {
        $(data.container).insertAfter($(container).closest('.order_object_container'));
        updateOrderControlButtons(data.characters_left);
      }
    });
  });

  function selectedCharacters() {
    var selectedCharacters = [];
    $.each($('.order_object'), function (index, element) {
      selectedCharacters.push($(element).data('objectId'));
    });
    return selectedCharacters
  }

  $(document).on('click', '.remove_order_object', function (event) {
    event.preventDefault();
    var container = $(this).closest('.order_object_container');
    container.remove();
    availableCharacters(function (characters, count) {
      // update selectors content
      updateOrderControlButtons(count);
    })
  });

  $('.order_object_selector').select2({
    theme: "bootstrap"
  });

  startTimePickers();
  startDatePickers();

});
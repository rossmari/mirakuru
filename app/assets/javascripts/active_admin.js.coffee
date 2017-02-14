#= require active_admin/base

#= require moment
#= require moment/ru

#= require bootstrap/transition
#= require bootstrap/collapse
#= require bootstrap-datetimepicker

#= require select2
#= require jquery.maskedinput.min

$(document).ready ->
  $('#actor_phone').mask("+7 (999) 999 99 99");
  $('#actor_contacts').mask("+7 (999) 999 99 99");

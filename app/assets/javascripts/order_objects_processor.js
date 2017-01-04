$(document).ready(function () {

  var orderObjects = {};

  function preloadOrderObjects() {
    $.ajax({
      type: "GET",
      url: '/api/order_objects',
      format: 'JSON',
      success: function(data) {
        orderObjects = data
      }
    });
  }

  preloadOrderObjects();

});
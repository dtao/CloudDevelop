$(document).ready(function() {
  $('#start-tabs').tabs();

  $('#start-dialog').dialog({
    draggable: false,
    height: 480,
    width: 640,
    buttons: {
      OK: function() {
        var name = $('#name').val();
        if (!name) {
          alert('You must enter a name.');
          return;
        }
        $('#start-form').submit();
      }
    }
  });
});
$(document).ready(function() {
  var $startForm, $startDialog;

  $('#start-tabs').tabs();

  $startForm = $('#start-form');

  $startDialog = $('#start-dialog').dialog({
    draggable: false,
    height: 480,
    width: 640,
    buttons: {
      OK: function() {
        $startForm.submit();
      }
    }
  });

  $startForm.submit(function() {
    var name = $('#name').val();
    if (!name) {
      alert('You must enter a name.');
      return false;
    }
  });

  $startDialog.bind('dialogbeforeclose', function() {
    alert('Enter your name and click "OK" in order to use CloudDevelop.');
    return false;
  });
});
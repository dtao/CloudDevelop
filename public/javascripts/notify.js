(function() {
  clouddevelop.notify = function(message) {
    var $notification = $('<div class="notification" style="display: none;">').text(message).appendTo('.notifications');
    $notification.slideDown('slow', function() {
      setTimeout(function() {
        $notification.slideUp('slow', function() {
          $notification.remove();
        });
      }, 2000);
    });
  };
}());
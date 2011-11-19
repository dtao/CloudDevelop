(function() {
  clouddevelop.notify = function(html) {
    var $notification =
          $('<div class="notification" style="display: none;">')
            .html(html)
            .appendTo('.notifications');
    
    $notification.slideDown('slow', function() {
      setTimeout(function() {
        $notification.slideUp('slow', function() {
          $notification.remove();
        });
      }, 4000);
    });
  };
}());
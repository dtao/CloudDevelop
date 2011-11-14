clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.throttle = function(func, milliseconds) {
    var waiting = false,
      restart = false,
      self = null,
      args = null;

    return function() {
      self = this;
      args = arguments;

      if (waiting) {
        restart = true;
        return;
      }

      waiting = true;
      setTimeout(function exec() {
        if (restart) {
          restart = false;
          setTimeout(exec, milliseconds);
        } else {
          window.console.log(new Date().toString() + ": raising 'update' event.");
          func.apply(self, args);
          waiting = false;
        }
      }, milliseconds);
    };
  };
}());
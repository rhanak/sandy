// Generated by CoffeeScript 1.4.0
(function() {

  (function() {
    var onError;
    Sandy.getLocation = function(success) {
      return navigator.geolocation.getCurrentPosition(success, onError);
    };
    return onError = function(error) {
      return alert('Could not get you location!' + 'code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
    };
  })();

}).call(this);
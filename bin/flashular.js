var __slice = [].slice;

angular.module("flashular", []).factory("flash", function($rootScope) {
  var flash;
  flash = null;
  $rootScope.$on("$locationChangeStart", function() {
    $rootScope.flash = angular.extend({}, flash);
    return flash = null;
  });
  return function() {
    var message, messageArgs, type;
    type = arguments[0], message = arguments[1], messageArgs = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    return flash = {
      type: type,
      message: message,
      messageArgs: messageArgs
    };
  };
});

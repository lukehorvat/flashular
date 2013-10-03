angular.module("flashular", []).factory("flash", function($rootScope) {
  var currentFlash, nextFlash;
  currentFlash = {};
  nextFlash = {};
  $rootScope.$on("$locationChangeStart", function() {
    var prop, _results;
    for (prop in currentFlash) {
      delete currentFlash[prop];
    }
    angular.extend(currentFlash, nextFlash);
    _results = [];
    for (prop in nextFlash) {
      _results.push(delete nextFlash[prop]);
    }
    return _results;
  });
  return function(k, v) {
    if (k != null) {
      nextFlash[k] = v;
    }
    return currentFlash;
  };
}).factory("f", function(flash) {
  return flash;
}).directive("flash", function(flash) {
  return {
    restrict: "E",
    replace: true,
    scope: {},
    template: "<div ng-show=\"flash\" class=\"flash\">\n  <div ng-show=\"flash.info\" class=\"alert alert-info\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('info')\">&times;</button>\n    {{flash.info}}\n  </div>\n  <div ng-show=\"flash.success\" class=\"alert alert-success\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('success')\">&times;</button>\n    {{flash.success}}\n  </div>\n  <div ng-show=\"flash.warning\" class=\"alert alert-warning\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('warning')\">&times;</button>\n    {{flash.warning}}\n  </div>\n  <div ng-show=\"flash.error\" class=\"alert alert-error\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('error')\">&times;</button>\n    {{flash.error}}\n  </div>\n</div>",
    link: function(scope) {
      scope.flash = flash();
      return scope.close = function(key) {
        return delete scope.flash[key];
      };
    }
  };
});

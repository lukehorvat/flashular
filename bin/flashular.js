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
}).directive("flashAlerts", function(flash, $interpolate) {
  return {
    restrict: "E",
    replace: true,
    scope: {
      transform: "&"
    },
    template: "<div ng-show=\"flash\" class=\"alerts\">\n  <div ng-show=\"flash.info\" class=\"alert alert-info\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('info')\">&times;</button>\n    {{flash.info ? transform({alert: flash.info}) : \"\"}}\n  </div>\n  <div ng-show=\"flash.success\" class=\"alert alert-success\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('success')\">&times;</button>\n    {{flash.success ? transform({alert: flash.success}) : \"\"}}\n  </div>\n  <div ng-show=\"flash.warning\" class=\"alert alert-warning\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('warning')\">&times;</button>\n    {{flash.warning ? transform({alert: flash.warning}) : \"\"}}\n  </div>\n  <div ng-show=\"flash.error\" class=\"alert alert-error\">\n    <button type=\"button\" class=\"close\" ng-click=\"close('error')\">&times;</button>\n    {{flash.error ? transform({alert: flash.error}) : \"\"}}\n  </div>\n</div>",
    link: function(scope, iElement, iAttrs) {
      scope.flash = flash();
      scope.close = function(key) {
        return delete scope.flash[key];
      };
      if (iAttrs.transform == null) {
        return scope.transform = function(alert) {
          return $interpolate("{{alert}}")(alert);
        };
      }
    }
  };
});

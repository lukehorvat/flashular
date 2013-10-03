angular.module("flashular", []).factory("flash", function($rootScope) {
  var currentFlash, nextFlash;
  currentFlash = {};
  nextFlash = {};
  $rootScope.$on("$locationChangeStart", function() {
    var prop, _results;
    for (prop in currentFlash) {
      delete currentFlash[prop];
    }
    currentFlash = angular.extend(currentFlash, nextFlash);
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
}).directive("flash", function(flash) {
  return {
    restrict: "E",
    replace: true,
    scope: {},
    template: "<div ng-show=\"flash\">\n  <div ng-show=\"flash.success\">{{flash.success}}</div>\n  <div ng-show=\"flash.error\">{{flash.error}}</div>\n  <div ng-show=\"flash.warning\">{{flash.warning}}</div>\n</div>",
    link: function(scope) {
      return scope.flash = flash();
    }
  };
});

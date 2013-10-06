angular.module('flashular', []).factory('flash', [
  '$rootScope',
  function ($rootScope) {
    var currentFlash, eventName, isModuleLoaded, nextFlash;
    currentFlash = {};
    nextFlash = {};
    isModuleLoaded = function (name) {
      var e;
      try {
        return angular.module(name) != null;
      } catch (_error) {
        e = _error;
        return false;
      }
    };
    if (isModuleLoaded('ngRoute')) {
      eventName = '$routeChangeSuccess';
    } else if (isModuleLoaded('ui.router')) {
      eventName = '$stateChangeSuccess';
    } else {
      eventName = '$locationChangeSuccess';
    }
    $rootScope.$on(eventName, function () {
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
    return function (k, v) {
      if (k != null) {
        if (v != null) {
          return nextFlash[k] = v;
        } else {
          return nextFlash[k];
        }
      } else {
        return currentFlash;
      }
    };
  }
]).directive('flashAlerts', [
  'flash',
  '$interpolate',
  function (flash, $interpolate) {
    return {
      restrict: 'E',
      replace: true,
      scope: { preProcess: '&' },
      template: '<div ng-show="flash" class="alerts">\n  <div ng-repeat="alertType in alertTypes" ng-show="flash[alertType]" class="alert alert-{{alertType}}">\n    <button type="button" class="close" ng-click="close(alertType)">&times;</button>\n    {{flash[alertType] ? preProcess({alert: flash[alertType]}) : ""}}\n  </div>\n</div>',
      link: function (scope, iElement, iAttrs) {
        scope.flash = flash();
        scope.alertTypes = [
          'info',
          'success',
          'error',
          'warning'
        ];
        scope.close = function (alertType) {
          return delete scope.flash[alertType];
        };
        if (iAttrs.preProcess == null) {
          return scope.preProcess = function (alert) {
            return $interpolate('{{alert}}')(alert);
          };
        }
      }
    };
  }
]);
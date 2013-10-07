var __hasProp = {}.hasOwnProperty, __extends = function (child, parent) {
    for (var key in parent) {
      if (__hasProp.call(parent, key))
        child[key] = parent[key];
    }
    function ctor() {
      this.constructor = child;
    }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.__super__ = parent.prototype;
    return child;
  };
angular.module('flashular', []).factory('flash', [
  '$rootScope',
  function ($rootScope) {
    var Flash, NextFlash, currentFlash, eventName, isModuleLoaded, nextFlash;
    Flash = function () {
      function Flash() {
        this.data = {};
      }
      Flash.prototype.set = function (k, v) {
        return this.data[k] = v;
      };
      Flash.prototype.get = function (k) {
        return this.data[k];
      };
      Flash.prototype.has = function (k) {
        return k in this.data;
      };
      Flash.prototype.remove = function (k) {
        return delete this.data[k];
      };
      Flash.prototype.clear = function () {
        var k, _results;
        _results = [];
        for (k in this.data) {
          _results.push(this.remove(k));
        }
        return _results;
      };
      return Flash;
    }();
    NextFlash = function (_super) {
      __extends(NextFlash, _super);
      function NextFlash(now) {
        NextFlash.__super__.constructor.apply(this, arguments);
        this.now = now;
      }
      NextFlash.prototype.transition = function (flash) {
        this.now.clear();
        angular.extend(this.now.data, this.data);
        return this.clear();
      };
      return NextFlash;
    }(Flash);
    currentFlash = new Flash();
    nextFlash = new NextFlash(currentFlash);
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
      return nextFlash.transition();
    });
    return nextFlash;
  }
]).directive('flashAlerts', [
  'flash',
  '$interpolate',
  function (flash, $interpolate) {
    return {
      restrict: 'E',
      replace: true,
      scope: { preProcess: '&' },
      template: '<div ng-show="flash" class="alerts">\n  <div ng-repeat="alertType in alertTypes" ng-show="flash.has(alertType)" class="alert alert-{{alertType}}">\n    <button type="button" class="close" ng-click="close(alertType)">&times;</button>\n    {{flash.has(alertType) ? preProcess({alert: flash.get(alertType)}) : ""}}\n  </div>\n</div>',
      link: function (scope, iElement, iAttrs) {
        scope.flash = flash.now;
        scope.alertTypes = [
          'info',
          'success',
          'error',
          'warning'
        ];
        scope.close = function (alertType) {
          return scope.flash.remove(alertType);
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
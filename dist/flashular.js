(function() {
  angular.module("flashular", []).factory("flash", function($rootScope) {
    var Flash, eventName, flash, isModuleLoaded;
    Flash = (function() {
      function Flash() {
        this.data = {};
      }

      Flash.prototype.set = function(k, v) {
        return this.data[k] = v;
      };

      Flash.prototype.get = function(k) {
        return this.data[k];
      };

      Flash.prototype.has = function(k) {
        return k in this.data;
      };

      Flash.prototype.remove = function(k) {
        return delete this.data[k];
      };

      Flash.prototype.clear = function() {
        var k, _results;
        _results = [];
        for (k in this.data) {
          _results.push(this.remove(k));
        }
        return _results;
      };

      Flash.prototype.isEmpty = function() {
        return this.data.length <= 0;
      };

      return Flash;

    })();
    isModuleLoaded = function(name) {
      var e;
      try {
        return angular.module(name) != null;
      } catch (_error) {
        e = _error;
        return false;
      }
    };
    if (isModuleLoaded("ngRoute")) {
      eventName = "$routeChangeSuccess";
    } else if (isModuleLoaded("ui.router")) {
      eventName = "$stateChangeSuccess";
    } else {
      eventName = "$locationChangeSuccess";
    }
    flash = new Flash;
    flash.now = new Flash;
    $rootScope.$on(eventName, function() {
      flash.now.clear();
      angular.extend(flash.now.data, flash.data);
      return flash.clear();
    });
    return flash;
  }).directive("flashAlerts", function(flash) {
    return {
      restrict: "E",
      replace: true,
      scope: {
        closeable: "=",
        preProcess: "="
      },
      template: "<div ng-show=\"flash\" class=\"alerts\">\n  <div ng-repeat=\"alertType in alertTypes\" ng-if=\"flash.has(alertType)\" class=\"alert alert-{{alertType}}\">\n    <button ng-if=\"closeable\" type=\"button\" class=\"close\" ng-click=\"flash.remove(alertType)\">&times;</button>\n    {{alert = flash.get(alertType); preProcess ? preProcess(alert) : alert}}\n  </div>\n</div>",
      link: function(scope) {
        scope.flash = flash.now;
        return scope.alertTypes = ["info", "success", "error", "warning", "danger"];
      }
    };
  });

}).call(this);

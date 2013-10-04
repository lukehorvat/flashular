angular.module("flashular", [])

.factory "flash", ($rootScope) ->

  currentFlash = {}
  nextFlash = {}

  $rootScope.$on "$locationChangeStart", ->
    delete currentFlash[prop] for prop of currentFlash
    angular.extend currentFlash, nextFlash
    delete nextFlash[prop] for prop of nextFlash

  (k, v) ->
    nextFlash[k] = v if k?
    currentFlash

.factory "f", (flash) ->
  flash

.directive "flashAlerts", (flash, $interpolate) ->

  restrict: "E"
  replace: true
  scope:
    transform: "&"
  template:
    """
    <div ng-show="flash" class="alerts">
      <div ng-show="flash.info" class="alert alert-info">
        <button type="button" class="close" ng-click="close('info')">&times;</button>
        {{transform({alert: flash.info})}}
      </div>
      <div ng-show="flash.success" class="alert alert-success">
        <button type="button" class="close" ng-click="close('success')">&times;</button>
        {{transform({alert: flash.success})}}
      </div>
      <div ng-show="flash.warning" class="alert alert-warning">
        <button type="button" class="close" ng-click="close('warning')">&times;</button>
        {{transform({alert: flash.warning})}}
      </div>
      <div ng-show="flash.error" class="alert alert-error">
        <button type="button" class="close" ng-click="close('error')">&times;</button>
        {{transform({alert: flash.error})}}
      </div>
    </div>
    """
  link: (scope, iElement, iAttrs) ->
    scope.flash = flash()
    scope.close = (key) -> delete scope.flash[key]
    if not iAttrs.transform?
      # Define a default transform function that just returns the passed-in value.
      scope.transform = (alert) -> $interpolate("{{alert}}")(alert)

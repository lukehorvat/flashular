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

.directive "flashAlerts", (flash, $interpolate) ->

  restrict: "E"
  replace: true
  scope:
    transform: "&"
  template:
    """
    <div ng-show="flash" class="alerts">
      <div ng-repeat="alertType in alertTypes" ng-show="flash[alertType]" class="alert alert-{{alertType}}">
        <button type="button" class="close" ng-click="close(alertType)">&times;</button>
        {{flash[alertType] ? transform({alert: flash[alertType]}) : ""}}
      </div>
    </div>
    """
  link: (scope, iElement, iAttrs) ->
    scope.alertTypes = ["info", "success", "error", "warning"]
    scope.flash = flash()
    scope.close = (alertType) -> delete scope.flash[alertType]
    if not iAttrs.transform?
      # Define a default transform function that just returns the passed-in value.
      scope.transform = (alert) -> $interpolate("{{alert}}")(alert)

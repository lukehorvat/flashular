angular.module("flashular", [])

.factory "flash", ($rootScope) ->

  currentFlash = {}
  nextFlash = {}

  $rootScope.$on "$locationChangeSuccess", ->
    delete currentFlash[prop] for prop of currentFlash
    angular.extend currentFlash, nextFlash
    delete nextFlash[prop] for prop of nextFlash

  (k, v) ->
    if k?
      if v? then nextFlash[k] = v else nextFlash[k]
    else
      currentFlash

.directive "flashAlerts", (flash, $interpolate) ->

  restrict: "E"
  replace: true
  scope:
    preProcess: "&"
  template:
    """
    <div ng-show="flash" class="alerts">
      <div ng-repeat="alertType in alertTypes" ng-show="flash[alertType]" class="alert alert-{{alertType}}">
        <button type="button" class="close" ng-click="close(alertType)">&times;</button>
        {{flash[alertType] ? preProcess({alert: flash[alertType]}) : ""}}
      </div>
    </div>
    """
  link: (scope, iElement, iAttrs) ->
    scope.flash = flash()
    scope.alertTypes = ["info", "success", "error", "warning"]
    scope.close = (alertType) -> delete scope.flash[alertType]
    if not iAttrs.preProcess?
      # Define a default preProcess function that does no processing of the alert.
      scope.preProcess = (alert) -> $interpolate("{{alert}}")(alert)

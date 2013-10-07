angular.module("flashular", [])

.factory "flash", ($rootScope) ->

  # Define the flash classes.
  class Flash
    constructor: -> @data = {}
    set: (k, v) -> @data[k] = v
    get: (k) -> @data[k]
    has: (k) -> k of @data
    remove: (k) -> delete @data[k]
    clear: -> @remove(k) for k of @data

  class NextFlash extends Flash
    constructor: ->
      super
      @now = new Flash

  flash = new NextFlash

  # Determine which event to listen for based on the installed router.
  isModuleLoaded = (name) ->
    try angular.module(name)? catch e then false

  if isModuleLoaded "ngRoute"
    eventName = "$routeChangeSuccess"
  else if isModuleLoaded "ui.router"
    eventName = "$stateChangeSuccess"
  else
    eventName = "$locationChangeSuccess"

  # Every route change, make the "next" flash become the "now" flash.
  $rootScope.$on eventName, ->
    flash.now.clear()
    angular.extend flash.now.data, flash.data
    flash.clear()

  return flash

.directive "flashAlerts", (flash, $interpolate) ->

  restrict: "E"
  replace: true
  scope:
    preProcess: "&"
  template:
    """
    <div ng-show="flash" class="alerts">
      <div ng-repeat="alertType in alertTypes" ng-show="flash.has(alertType)" class="alert alert-{{alertType}}">
        <button type="button" class="close" ng-click="close(alertType)">&times;</button>
        {{flash.has(alertType) ? preProcess({alert: flash.get(alertType)}) : ""}}
      </div>
    </div>
    """
  link: (scope, iElement, iAttrs) ->
    scope.flash = flash.now
    scope.alertTypes = ["info", "success", "error", "warning"]
    scope.close = (alertType) -> scope.flash.remove(alertType)
    if not iAttrs.preProcess?
      # Define a default preProcess function that does no processing of the alert.
      scope.preProcess = (alert) -> $interpolate("{{alert}}")(alert)

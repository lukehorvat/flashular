angular.module "flashular", []

.factory "flash", ($rootScope) ->

  # Define the flash class.
  class Flash
    constructor: -> @data = {}
    set: (k, v) -> @data[k] = v
    get: (k) -> @data[k]
    has: (k) -> k of @data
    remove: (k) -> delete @data[k]
    clear: -> @remove(k) for k of @data
    isEmpty: -> @data.length <= 0

  # Determine which event to listen for based on the installed router.
  isModuleLoaded = (name) -> try angular.module(name)? catch e then false

  eventName = switch
    when isModuleLoaded("ngRoute") then "$routeChangeSuccess"
    when isModuleLoaded("ui.router") then "$stateChangeSuccess"
    else "$locationChangeSuccess"

  # Every route change, make the "next" flash become the "now" flash.
  flash = new Flash
  flash.now = new Flash
  $rootScope.$on eventName, ->
    flash.now.clear()
    angular.extend flash.now.data, flash.data
    flash.clear()

  return flash

.directive "flashAlerts", (flash) ->

  restrict: "E"
  replace: yes
  scope:
    closeable: "="
    preProcess: "="
  template:
    """
    <div ng-show="flash" class="alerts">
      <div ng-repeat="alertType in alertTypes" ng-if="flash.has(alertType)" class="alert alert-{{alertType}}">
        <button ng-if="closeable" type="button" class="close" ng-click="flash.remove(alertType)">&times;</button>
        {{alert = flash.get(alertType); preProcess ? preProcess(alert) : alert}}
      </div>
    </div>
    """
  link: (scope) ->
    scope.flash = flash.now
    scope.alertTypes = ["info", "success", "error", "warning", "danger"]

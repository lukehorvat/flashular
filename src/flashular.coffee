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

.directive "flash", (flash) ->

  restrict: "E"
  replace: true
  scope: {}
  template: """
    <div ng-show="flash" class="flash">
      <div ng-show="flash.info" class="alert alert-info">
        <button type="button" class="close" ng-click="close('info')">&times;</button>
        {{flash.info}}
      </div>
      <div ng-show="flash.success" class="alert alert-success">
        <button type="button" class="close" ng-click="close('success')">&times;</button>
        {{flash.success}}
      </div>
      <div ng-show="flash.warning" class="alert alert-warning">
        <button type="button" class="close" ng-click="close('warning')">&times;</button>
        {{flash.warning}}
      </div>
      <div ng-show="flash.error" class="alert alert-error">
        <button type="button" class="close" ng-click="close('error')">&times;</button>
        {{flash.error}}
      </div>
    </div>
    """
  link: (scope) ->
    scope.flash = flash()
    scope.close = (key) -> delete scope.flash[key]

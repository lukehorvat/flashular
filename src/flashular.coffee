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
    <div ng-show="flash">
      <div ng-show="flash.success">{{flash.success}}</div>
      <div ng-show="flash.error">{{flash.error}}</div>
      <div ng-show="flash.warning">{{flash.warning}}</div>
    </div>
    """
  link: (scope) ->
    scope.flash = flash()

angular.module("flashular", [])

.factory "flash", ($rootScope) ->

  flash = null
  $rootScope.$on "$locationChangeStart", ->
    $rootScope.flash = angular.extend {}, flash
    flash = null

  (type, message, messageArgs...) ->
    flash = { type: type, message: message, messageArgs: messageArgs }

.directive "flash", ->

  restrict: "E"
  template:"""
    <div ng-show="flash">
      {{flash.message}}
    </div>
    """

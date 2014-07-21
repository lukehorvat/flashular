angular.module("app", [
  "flashular"
]).run(function(flash) {
  flash.now.set("success", "App started!");
});

flashular
=========

A simple flash service for AngularJS that provides a means with which to pass temporary objects between routes (or "states", if using [UI Router](https://github.com/angular-ui/ui-router) terminology). Anything you place in the flash is exposed to the very next route and then immediately cleared out, making it somewhat similar to the [Rails flash](http://api.rubyonrails.org/classes/ActionDispatch/Flash.html). Also comes with a Twitter Bootstrap-compatible directive for displaying flash alerts.

## Installation

You can manually add the [flashular.js](/bin/flashular.js) file to your AngularJS application, or install it with Bower:

```bash
$ bower install flashular --save-dev
```

After that, just add Flashular to any Angular module's dependency list:

```coffeescript
angular.module("app", ["flashular"])
```

## Service

Flashular provides a **flash** service that allows you to temporarily store values of *any* type (e.g. strings, arrays, objects, etc.), and retrieve them when the [$location](http://docs.angularjs.org/api/ng.$location) changes. Values are only stored in the flash for a maximum of one $location change before being cleared out.

To use the flash service, simply inject it as a dependency in your Angular controller:

```coffeescript
.controller "SignInCtrl", (flash) ->
```

The injected flash service is a function that can be called to **set** values for the *next* $location or **get** values intended for the *current* $location (i.e. stuff stored in the flash during the previous $location).

To store a value for the next $location, call the function with a key and value pair:

```coffeescript
flash("user", { firstName: "John", lastName: "Smith", age: 30 })
```

To retrieve a value for the current $location, call the function without specifying any arguments. This will return a flash object that you can query however you want:

```coffeescript
f = flash()
user = f["user"]
```

## Directive

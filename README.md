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
flash("username", "John Smith")
```

To retrieve a value for the current $location, call the function without specifying any arguments. This will return a flash object that you can query however you want:

```coffeescript
f = flash()
username = f["username"]
```

## Directive

Flashular also provides a **flashAlerts** directive that allows you to easily display "alerts" in your HTML templates. Anything you store in the flash with a key of `info`, `success`, `warning`, or `error` will automatically be rendered as an alert wherever you include this directive in your templates. Furthermore, the HTML outputted by this directive is completely compatible with Twitter Bootstrap (and doesn't require [UI Bootstrap](https://github.com/angular-ui/bootstrap) either!).

Adding the flashAlerts directive to a template can be done like so:

```
<flash-alerts></flash-alerts>
```

**Need to do some pre-processing of your alerts before they are rendered?** Just add a `preProcess` attribute, which should be a function that accepts a single argument (the alert stored in the flash, which can be *any* type) and returns the "processed" alert (which should be something renderable, like a string):

```
<flash-alerts pre-process="processFlashAlert(alert)"></flash-alerts>
```

How might this be useful? Well, flash alerts are definitely something you want to localize, for example. But a lot of i18n libraries out there tend to load their translation dictionaries asynchronously. So what if you want to store a translated alert string in the flash, but i18n hasn't finished loading yet. You can't do it. Or can you?

Flashular automatically detects changes to the return value of your `preProcess` function (using [$interpolate](http://docs.angularjs.org/api/ng.$interpolate) magic) and re-renders alerts as needed. So if your i18n library returns null or an empty string if you try to use it before it has finished loading, and a translated string once it has loaded, then it's pretty obvious what you should do - perform the translation inside your `preProcess` function!

Still not clear? Below is an example:

```coffeescript
# Define a translation in your i18n dictionary.
{"key": "SIGN_IN_SUCCESS", "value": "You signed in successfully. Welcome back, %s!"}
```

```coffeescript
# Store the i18n dictionary key in the flash along with any strings to substitute.
flash("success", ["SIGN_IN_SUCCESS", username])
```

```coffeescript
# Perform translations and string substituting in the preProcess function.
$rootScope.processFlashAlert = (alert) ->
  [message, args...] = alert
  stringUtils.format(i18n.translate(message), args...)
```

![Alert example](http://i.imgur.com/DGZ7sgg.png)

## Contributing

All contributions are welcome.

As you've probably noticed, Flashular development has been set up to take advantage of [Bower](https://github.com/bower/bower) and [Grunt](https://github.com/gruntjs/grunt). Perhaps a tad overkill for a project of this size, but then again you don't *have* to use them. If you do, just run `npm install` and `bower install` to get your dependencies sorted out.

Make your changes to [flashular.coffee](/src/flashular.coffee), but ensure you also commit the compiled [flashular.js](/bin/flashular.js). Run the `grunt watch` task to auto-compile CoffeeScript to JavaScript as you work.

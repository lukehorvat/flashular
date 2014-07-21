require "should"

describe "flashular", ->

  it "should... work", ->

    get = browser.get("#/")
    flash = element(By.id("test-flash"))
    displayed = flash.isDisplayed().then (d) -> d.should.be.a.Boolean.and.be.true
    text = flash.getText().then (t) -> t.should.be.a.String.and.equal "App started!"

    return get.then -> flash.then -> displayed.then -> text

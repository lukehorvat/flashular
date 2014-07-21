require "should"

describe "flashular", ->

  it "should... work", ->

    browser.get("#/").then ->
      flash = element(By.id("test-flash"))
      flash.isDisplayed().then (displayed) -> displayed.should.be.a.Boolean.and.be.true
      flash.getText().then (text) -> text.should.be.a.String.and.equal "App started!"

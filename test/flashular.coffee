describe "flashular", ->

  it "should... work", ->

    browser.get "#/"
    flash = element By.id("test-flash")
    expect(flash.isDisplayed()).toBe yes
    expect(flash.getText()).toBe "App started!"

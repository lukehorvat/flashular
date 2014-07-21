require "should"

describe "flashular", ->

  it "should... work", ->

    browser.get "/"
    .then ->
      browser.getTitle()
    .then (title) ->
      title.should.be.a.String.and.equal "Hello"

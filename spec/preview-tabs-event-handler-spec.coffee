{$}  = require "atom"
PreviewTabsEventHandler = require "../lib/preview-tabs-event-handler"

describe "PreviewTabsPrevew", ->
  previewTabsEventHandler = null
  element = null
  view = null

  class TestView
    callback: ->

  beforeEach ->
    element = $(document.createElement("div"))
    view = new TestView()
    spyOn(view, "callback")
    previewTabsEventHandler = new PreviewTabsEventHandler(element, "click", null, view.callback)

  afterEach ->
    element.remove()

  it "attaches the event handler", ->
    expect(view.callback).not.toHaveBeenCalled()
    element.trigger("click")
    expect(view.callback).toHaveBeenCalled()

  it "removes the event handler when disposed", ->
    previewTabsEventHandler.dispose()
    element.trigger("click")
    expect(view.callback).not.toHaveBeenCalled()

  it "indicates if it is disposed or not", ->
    expect(previewTabsEventHandler.disposed).toBe false
    previewTabsEventHandler.dispose()
    expect(previewTabsEventHandler.disposed).toBe true

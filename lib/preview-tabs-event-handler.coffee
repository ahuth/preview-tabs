module.exports =
class PreviewTabsEventHandler
  constructor: (@element, @eventName, @target, @callback) ->
    @element.on @eventName, @target, @callback
    @disposed = false

  dispose: ->
    @element.off @eventName, @target, @callback
    @disposed = true

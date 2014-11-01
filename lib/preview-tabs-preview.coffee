PreviewTabsEventHandler = require "./preview-tabs-event-handler"

# PreviewTabsPreview closes or makes permanent its tab/editor under certain
# conditions.
module.exports =
class PreviewTabsPreview
  constructor: (@pane, @editor, @tab, @destroyNotifier) ->
    @tab.addClass("preview-tabs-preview")
    @subscriptions =
      itemSaved: @editor.onDidSave? => @keep()
      itemChanged: @editor.onDidChangeModified? => @keep()
      tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, => @keep())

  destroy: ->
    subscription?.dispose() for own name, subscription of @subscriptions
    @destroyNotifier?()

  close: ->
    @pane.destroyItem(@editor)
    @destroy()

  keep: ->
    @tab.removeClass("preview-tabs-preview")
    @destroy()

  keepIf: (path) ->
    @keep() if path is @editor.getPath()

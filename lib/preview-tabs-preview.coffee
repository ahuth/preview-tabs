PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsPreview
  constructor: (@editor, @destroyNotifier) ->
    @_waitsForEditorReady =>
      @tab = atom.workspaceView.getActivePaneView().find(".tab.active")
      @subscriptions =
        itemSaved: @editor.onDidSave => @keep()
        itemChanged: @editor.onDidChange => @keep()
        tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, => @keep())
      @tab.addClass("preview-tabs-preview")

  destroy: ->
    subscription.dispose() for own name, subscription of @subscriptions
    @destroyNotifier?()

  close: ->
    @editor.destroy()
    @destroy()

  keep: ->
    @tab.removeClass("preview-tabs-preview")
    @destroy()

  keepIf: (fileName) ->
    @keep() if fileName is @editor.getTitle()

  _waitsForEditorReady: (callback) ->
    subscription = @editor.onDidChange ->
      callback?()
      subscription.dispose()

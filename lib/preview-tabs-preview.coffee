PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsPreview
  constructor: (@editor, @tab, @destroyNotifier) ->
    @tab.addClass("preview-tabs-preview")
    @subscriptions =
      itemSaved: @editor.onDidSave @_onDidSave
      itemChanged: @editor.onDidChange @_onDidChange
      tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, @_onDidDoubleClickTab)

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

  _onDidSave: =>
    @keep()

  _onDidChange: =>
    @keep() if @editorReady
    @editorReady = true

  _onDidDoubleClickTab: =>
    @keep()

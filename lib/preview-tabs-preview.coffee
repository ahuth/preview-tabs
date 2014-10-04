PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsPreview
  constructor: (paneItem, @destroyNotifier) ->
    @item = paneItem.item
    @_waitsForItemReady =>
      @tab = atom.workspaceView.getActivePaneView().find(".tab.active")
      @subscriptions =
        itemSaved: @item.onDidSave => @keep()
        itemChanged: @item.onDidChange => @keep()
        tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, => @keep())
      @tab.addClass("preview-tabs-preview")

  destroy: ->
    subscription.dispose() for own name, subscription of @subscriptions
    @destroyNotifier?()

  close: ->
    @item.destroy()
    @destroy()

  keep: ->
    @tab.removeClass("preview-tabs-preview")
    @destroy()

  keepIf: (fileName) ->
    @keep() if fileName is @item.getTitle()

  _waitsForItemReady: (callback) ->
    subscription = @item.onDidChange ->
      callback?()
      subscription.dispose()

PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsPreview
  constructor: (paneItem, @closeNotifier) ->
    @item = paneItem.item
    @_waitsForItemReady =>
      @tab = atom.workspaceView.getActivePaneView().find(".tab.active")
      @subscriptions =
        itemSaved: @item.onDidSave @_onDidSaveItem
        itemChanged: @item.onDidChange @_onDidChangeItem
        tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, @_onTabDoubleClicked)
      @tab.addClass("preview-tabs-preview")

  destroy: ->
    subscription.dispose() for own name, subscription of @subscriptions
    @closeNotifier?()

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

  _onDidSaveItem: =>
    @keep()

  _onDidChangeItem: =>
    @keep()

  _onTabDoubleClicked: =>
    @keep()

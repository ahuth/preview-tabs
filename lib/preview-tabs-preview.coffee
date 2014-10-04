PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsPreview
  constructor: (paneItem) ->
    @item = paneItem.item
    @_waitsForItemReady =>
      @tab = atom.workspaceView.getActivePaneView().find(".tab.active")
      @subscriptions =
        itemSaved: @item.onDidSave @_onDidSaveItem
        itemChanged: @item.onDidChange @_onDidChangeItem
        tabDoubleClicked: new PreviewTabsEventHandler(@tab, "dblclick", null, @_onTabDoubleClicked)

  destroy: ->
    subscription.dispose() for own name, subscription of @subscriptions

  close: ->
    @destroy()

  keep: ->
    @destroy()

  keepIf: (fileName) ->
    @keep() if fileName is @item.getTitle()

  _waitsForItemReady: (callback) ->
    subscription = @item.onDidChange ->
      callback?()
      subscription.dispose()

  _onDidSaveItem: =>
    console.log "saved"

  _onDidChangeItem: =>
    console.log "changed"

  _onTabDoubleClicked: =>
    console.log "clicked"

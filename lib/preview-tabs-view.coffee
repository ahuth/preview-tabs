{View} = require "atom"
PreviewTabsPreview = require "./preview-tabs-preview"
PreviewTabsEventHandler = require "./preview-tabs-event-handler"

module.exports =
class PreviewTabsView extends View
  @content: ->
    @div class: "preview-tabs"

  initialize: (paneView) ->
    @preview = null
    @pane = paneView.model
    @subscriptions =
      paneItemAdded: @pane.onDidAddItem @_onPaneItemAdded
      treeEntryDoubleClicked: new PreviewTabsEventHandler(atom.workspaceView, "dblclick", ".tree-view .entry", @_onTreeEntryDoubleClicked)

  remove: ->
    @unsubscribe()
    @preview?.destroy()
    super

  unsubscribe: ->
    subscription.dispose() for own name, subscription of @subscriptions
    super

  _onPaneItemAdded: (item) =>
    @preview?.close()
    @preview = new PreviewTabsPreview(item)

  _onTreeEntryDoubleClicked: (event) =>
    fileName = event.target.innerText
    @preview?.keepIf(fileName)

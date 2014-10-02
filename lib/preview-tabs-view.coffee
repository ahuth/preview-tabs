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
      tabDblClicked: new PreviewTabsEventHandler(paneView, "dblclick", ".tab", @_onTabDoubleClicked)

  remove: ->
    @unsubscribe()
    @preview?.destroy()
    super

  unsubscribe: ->
    subscription.dispose() for own name, subscription of @subscriptions
    super

  _onPaneItemAdded: (item) ->
    @preview?.close()
    @preview = new PreviewTabsPreview(item)

  _onTabDoubleClicked: (event) =>
    return unless @preview?
    @preview.keep()
    @preview.destroy()
    @preview = null

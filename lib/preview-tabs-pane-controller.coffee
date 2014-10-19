PreviewTabsPreview = require "./preview-tabs-preview"
PreviewTabsEventHandler = require "./preview-tabs-event-handler"

# PreviewTabsPaneController creates and manages the preview for its pane.
module.exports =
class PreviewTabsPaneController
  constructor: (@paneView) ->
    @preview = null
    @pane = paneView.model
    @subscriptions =
      paneItemAdded: @pane.onDidAddItem @_onPaneItemAdded
      treeEntryDoubleClicked: new PreviewTabsEventHandler(atom.workspaceView, "dblclick", ".tree-view .file", @_onTreeEntryDoubleClicked)

    @_deferUntilTabsLoaded =>
      @tabBar = @paneView.find(".tab-bar")
      @subscriptions.tabDropped = new PreviewTabsEventHandler(@tabBar, "drop", null, @_onTabDropped)

  remove: ->
    subscription.dispose() for own name, subscription of @subscriptions
    @preview?.destroy()

  _deferUntilTabsLoaded: (callback) ->
    setTimeout (->callback?()), 1

  _onPaneItemAdded: (paneItem) =>
    return unless paneItem.item.buffer?
    @preview?.close()
    editor = paneItem.item
    tab = @_findTabForEditor(editor)
    @preview = new PreviewTabsPreview(editor, tab, => @preview = null)

  _onTreeEntryDoubleClicked: (event) =>
    path = event.target.getAttribute("data-path")
    @preview?.keepIf(path)

  _onTabDropped: (event) =>
    @preview?.keep()

  _findTabForEditor: (editor) ->
    path = editor.getPath()
    @paneView.find(".tab [data-path='#{path}']")

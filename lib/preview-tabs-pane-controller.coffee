_ = require "underscore-plus"
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
      tabDropped: new PreviewTabsEventHandler(@paneView, "drop", ".tab-bar", @_onTabDropped)

  remove: ->
    subscription.dispose() for own name, subscription of @subscriptions
    @preview?.destroy()

  _onPaneItemAdded: (paneItem) =>
    return unless @_shouldPreviewItem(paneItem.item)
    @preview?.close()
    editor = paneItem.item
    _.defer =>
      tab = @_findTabForEditor(editor)
      @preview = new PreviewTabsPreview(@pane, editor, tab, => @preview = null)

  _onTreeEntryDoubleClicked: (event) =>
    path = event.target.getAttribute("data-path") || event.target.children[0].getAttribute("data-path")
    @preview?.keepIf(path)

  _onTabDropped: (event) =>
    @preview?.keep()

  _findTabForEditor: (editor) ->
    path = editor.getPath()
    @paneView.find(".tab [data-path='#{path}']")

  _shouldPreviewItem: (item) ->
    item.constructor.name in ["TextEditor", "ImageEditor"]

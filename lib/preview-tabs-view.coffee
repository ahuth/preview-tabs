{View} = require "atom"
PreviewTabsPreview = require "./preview-tabs-preview"
PreviewTabsEventHandler = require "./preview-tabs-event-handler"

# PreviewTabsView manages the preview for its pane, including creating and
# destroying.
module.exports =
class PreviewTabsView extends View
  @content: ->
    @div class: "preview-tabs"

  initialize: (@paneView) ->
    @preview = null
    @pane = paneView.model
    @subscriptions =
      paneItemAdded: @pane.onDidAddItem @_onPaneItemAdded
      treeEntryDoubleClicked: new PreviewTabsEventHandler(atom.workspaceView, "dblclick", ".tree-view .file", @_onTreeEntryDoubleClicked)

    setTimeout =>
      @tabBar = @paneView.find(".tab-bar")
      @subscriptions.tabDropped = new PreviewTabsEventHandler(@tabBar, "drop", null, @_onTabDropped)
    , 1

  remove: ->
    @unsubscribe()
    @preview?.destroy()
    super

  unsubscribe: ->
    subscription.dispose() for own name, subscription of @subscriptions
    super

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

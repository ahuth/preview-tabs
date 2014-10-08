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
      treeEntryDoubleClicked: new PreviewTabsEventHandler(atom.workspaceView, "dblclick", ".tree-view .file", @_onTreeEntryDoubleClicked)

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
    editorTitle = editor.getTitle()
    tab = atom.workspaceView.find(".tab [data-name='#{editorTitle}']").parent()
    @preview = new PreviewTabsPreview(editor, tab, => @preview = null)

  _onTreeEntryDoubleClicked: (event) =>
    fileName = event.target.innerText
    @preview?.keepIf(fileName)

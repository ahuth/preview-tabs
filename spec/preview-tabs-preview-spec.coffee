{$, WorkspaceView, TextEditorView}  = require "atom"
PreviewTabsPreview = require "../lib/preview-tabs-preview"

describe "PreviewTabsPreview", ->
  previewTabsPreview = null
  editor = null
  tab = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    editor = new TextEditorView({}).getEditor()
    tab = $(document.createElement("li"))
    previewTabsPreview = new PreviewTabsPreview(editor, tab, -> true)

  describe "destroying", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPreview.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPreview.destroy()
      expect(subscription.disposed).toBe true for subscription in subscriptions

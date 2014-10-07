{$, WorkspaceView, TextEditorView}  = require "atom"
PreviewTabsPreview = require "../lib/preview-tabs-preview"

describe "PreviewTabsPreview", ->
  previewTabsPreview = null
  editor = null
  tab = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    tab = $(document.createElement("li"))
    editor = new TextEditorView({}).getEditor()
    previewTabsPreview = new PreviewTabsPreview(editor, tab, -> true)

  describe "creating", ->
    it "adds the preview-tabs-preview class to its tab", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true

  describe "keeping", ->
    it "keeps the tab when it is double clicked", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true
      tab.trigger("dblclick")
      expect(tab.hasClass("preview-tabs-preview")).toBe false

    it "keeps the tab when the editor is saved", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true
      editor.buffer.emitter.emit("did-save")
      expect(tab.hasClass("preview-tabs-preview")).toBe false

    it "keeps the tab when the editor is modified", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true
      editor.setText("hello")
      editor.setText("world")
      expect(tab.hasClass("preview-tabs-preview")).toBe false

  describe "destroying", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPreview.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPreview.destroy()
      expect(subscription.disposed).toBe true for subscription in subscriptions

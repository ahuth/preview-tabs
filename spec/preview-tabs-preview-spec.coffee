{$, WorkspaceView, TextEditorView}  = require "atom"
PreviewTabsPreview = require "../lib/preview-tabs-preview"

describe "PreviewTabsPreview", ->
  previewTabsPreview = null
  pane = null
  editor = null
  tab = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePane()
    editor = new TextEditorView({}).getEditor()
    pane.addItem(editor)
    tab = $(document.createElement("li")).html("test.js")
    previewTabsPreview = new PreviewTabsPreview(pane, editor, tab, -> true)

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
      editor.buffer.emitter.emit("did-change-modified")
      expect(tab.hasClass("preview-tabs-preview")).toBe false

  describe "keepIf", ->
    beforeEach ->
      editor.buffer.setPath("/path/1/test.js")

    it "keeps the tab if the tab if the file's path matches the editor's", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true
      previewTabsPreview.keepIf("/path/1/test.js")
      expect(tab.hasClass("preview-tabs-preview")).toBe false

    it "does not keep the tab if the file's path does not match the editor's", ->
      expect(tab.hasClass("preview-tabs-preview")).toBe true
      previewTabsPreview.keepIf("/path/2/test.js")
      expect(tab.hasClass("preview-tabs-preview")).toBe true

  describe "destroying", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPreview.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPreview.destroy()
      expect(subscription.disposed).toBe true for subscription in subscriptions

    it "calls its destroy notifier", ->
      spyOn(previewTabsPreview, "destroyNotifier")
      previewTabsPreview.destroy()
      expect(previewTabsPreview.destroyNotifier).toHaveBeenCalled()

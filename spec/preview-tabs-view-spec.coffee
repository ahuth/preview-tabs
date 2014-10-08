{$, WorkspaceView, TextEditorView}  = require "atom"
PreviewTabsView = require "../lib/preview-tabs-view"

describe "PreviewTabsView", ->
  pane = null
  previewTabsView = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePaneView()
    previewTabsView = new PreviewTabsView(pane)

  describe "adding pane items", ->
    editor = null

    beforeEach ->
      editor = new TextEditorView({}).getEditor()

    it "adds a new preview", ->
      expect(previewTabsView.preview).toBeFalsy()
      pane.addItem(editor)
      expect(previewTabsView.preview).toBeTruthy()

    it "closes the old preview if there is one", ->
      pane.addItem(editor)
      closeSpy = spyOn(previewTabsView.preview, "close")

      editor2 = new TextEditorView({}).getEditor()
      pane.addItem(editor2)
      expect(closeSpy).toHaveBeenCalled()

    describe "when a tree entry is double clicked", ->
      tree = null

      beforeEach ->
        editor.getTitle = -> "test.js"
        tree = $(document.createElement("ol")).addClass("tree-view")
        tree.html('<li class="file entry" data-name="test.js">test.js</li>')
        atom.workspaceView.prepend(tree)

      it "keeps the newly opened file", ->
        pane.addItem(editor)
        expect(previewTabsView.preview).toBeTruthy()
        tree.find(".file").trigger("dblclick")
        expect(previewTabsView.preview).toBeFalsy()

  describe "removing", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsView.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsView.remove()
      expect(subscription.disposed).toBe true for subscription in subscriptions

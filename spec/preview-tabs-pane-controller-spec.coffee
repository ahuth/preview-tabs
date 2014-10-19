{$, WorkspaceView, TextEditorView, View}  = require "atom"
PreviewTabsPaneController = require "../lib/preview-tabs-pane-controller"

describe "PreviewTabsPaneController", ->
  pane = null
  previewTabsPaneController = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePaneView()
    previewTabsPaneController = new PreviewTabsPaneController(pane)

  describe "adding pane items", ->
    editor = null

    beforeEach ->
      editor = new TextEditorView({}).getEditor()

    it "adds a new preview", ->
      expect(previewTabsPaneController.preview).toBeFalsy()
      pane.addItem(editor)
      expect(previewTabsPaneController.preview).toBeTruthy()

    it "closes the old preview if there is one", ->
      pane.addItem(editor)
      closeSpy = spyOn(previewTabsPaneController.preview, "close")

      editor2 = new TextEditorView({}).getEditor()
      pane.addItem(editor2)
      expect(closeSpy).toHaveBeenCalled()

    it "previews text and image editors", ->
      expect(previewTabsPaneController._shouldPreviewItem(editor)).toBe true
      imageEditor = new class ImageEditor
      expect(previewTabsPaneController._shouldPreviewItem(imageEditor)).toBe true

    it "does not preview non-editor views", ->
      settingsView = new class SettingsView
      expect(previewTabsPaneController._shouldPreviewItem(settingsView)).toBe false

    describe "when a tree entry is double clicked", ->
      tree = null

      beforeEach ->
        editor.buffer.setPath("/path/test.js")
        tree = $(document.createElement("ol")).addClass("tree-view")
        tree.html('<li class="file entry" data-path="/path/test.js">test.js</li>')
        atom.workspaceView.prepend(tree)

      afterEach ->
        tree.remove()

      it "keeps the newly opened file", ->
        pane.addItem(editor)
        expect(previewTabsPaneController.preview).toBeTruthy()
        tree.find(".file").trigger("dblclick")
        expect(previewTabsPaneController.preview).toBeFalsy()

    describe "when another item already has the same name", ->
      tab1 = null
      tab2 = null

      beforeEach ->
        tab1 = $(document.createElement("li")).addClass("tab")
        tab2 = $(document.createElement("li")).addClass("tab")
        tab1.html "<div data-name='test.js' data-path='/path/1/test.js'>test1.js</div>"
        tab2.html "<div data-name='test.js' data-path='/path/2/test.js'>test1.js</div>"
        pane.prepend(tab1, tab2)

        editor.getTitle = -> "test.js"
        editor.buffer.setPath("/path/2/test.js")

      afterEach ->
        tab1.remove()
        tab2.remove()

      it "does not send the first item's tab to the preview", ->
        expect(previewTabsPaneController._findTabForEditor(editor).length).toBe 1

  describe "removing", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPaneController.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPaneController.remove()
      expect(subscription.disposed).toBe true for subscription in subscriptions

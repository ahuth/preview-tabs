{$, WorkspaceView, TextEditorView, View}  = require "atom"
PreviewTabsPaneView = require "../lib/preview-tabs-pane-view"

describe "PreviewTabsPaneView", ->
  pane = null
  previewTabsPaneView = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePaneView()
    previewTabsPaneView = new PreviewTabsPaneView(pane)

  describe "adding pane items", ->
    editor = null

    class GenericView extends View
      @content: -> @div "test"
      initialize: ->

    beforeEach ->
      editor = new TextEditorView({}).getEditor()

    it "adds a new preview", ->
      expect(previewTabsPaneView.preview).toBeFalsy()
      pane.addItem(editor)
      expect(previewTabsPaneView.preview).toBeTruthy()

    it "closes the old preview if there is one", ->
      pane.addItem(editor)
      closeSpy = spyOn(previewTabsPaneView.preview, "close")

      editor2 = new TextEditorView({}).getEditor()
      pane.addItem(editor2)
      expect(closeSpy).toHaveBeenCalled()

    it "does not preview items without a buffer", ->
      expect(previewTabsPaneView.preview).toBeFalsy()
      genericView = new GenericView()
      pane.addItem(genericView)
      expect(previewTabsPaneView.preview).toBeFalsy()

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
        expect(previewTabsPaneView.preview).toBeTruthy()
        tree.find(".file").trigger("dblclick")
        expect(previewTabsPaneView.preview).toBeFalsy()

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
        expect(previewTabsPaneView._findTabForEditor(editor).length).toBe 1

  describe "removing", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPaneView.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPaneView.remove()
      expect(subscription.disposed).toBe true for subscription in subscriptions

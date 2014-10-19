{WorkspaceView} = require "atom"
PreviewTabsPanesManager = require "../lib/preview-tabs-panes-manager"

describe "PreviewTabsPanesManager", ->
  pane = null
  previewTabsPanesManager = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePaneView()
    previewTabsPanesManager = new PreviewTabsPanesManager()

  describe "creating", ->
    it "adds a previews tabs view to existing panes", ->
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 1

  describe "adding panes", ->
    it "adds preview tabs views to new panes", ->
      pane.splitRight(pane.copyActiveItem())
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 2

  describe "removing panes", ->
    it "removes preview tabs views from destroyed panes", ->
      pane.splitRight(pane.copyActiveItem())
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 2
      atom.workspaceView.destroyActivePane()
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 1

  describe "destroying", ->
    it "removes all preview tabs views", ->
      pane.splitRight(pane.copyActiveItem())
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 2

      previewTabsPanesManager.destroy()
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 0

    it "stops adding preview tabs views", ->
      previewTabsPanesManager.destroy()
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 0

      pane.splitRight(pane.copyActiveItem())
      expect(previewTabsPanesManager.previewTabsPaneViews.length).toBe 0

{WorkspaceView} = require "atom"
PreviewTabs = require "../lib/preview-tabs"

describe "PreviewTabs", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage("preview-tabs")

  describe "activation", ->
    it "adds preview tabs views to existing panes", ->
      expect(PreviewTabs.previewTabsViews.length).toBe 1

  describe "deactivation", ->
    it "removes all preview tabs views", ->
      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(PreviewTabs.previewTabsViews.length).toBe 2

      atom.packages.deactivatePackage("preview-tabs")
      expect(PreviewTabs.previewTabsViews.length).toBe 0

    it "stops adding preview tabs views", ->
      atom.packages.deactivatePackage("preview-tabs")
      expect(PreviewTabs.previewTabsViews.length).toBe 0

      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(PreviewTabs.previewTabsViews.length).toBe 0

  describe "adding and removing panes", ->
    it "adds a preview tabs view to new panes", ->
      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(PreviewTabs.previewTabsViews.length).toBe 2

    it "removes the corresponding preview tabs view from destroyed panes", ->
      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())

      expect(PreviewTabs.previewTabsViews.length).toBe 2
      atom.workspaceView.destroyActivePane()
      expect(PreviewTabs.previewTabsViews.length).toBe 1

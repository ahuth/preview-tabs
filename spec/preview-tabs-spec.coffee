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
      expect(atom.workspaceView.panes.find(".pane").length).toBe 1
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 1

    it "adds preview tabs views to new panes", ->
      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(atom.workspaceView.find(".pane").length).toBe 2
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 2

  describe "deactivation", ->
    it "removes all preview tabs views", ->
      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(atom.workspaceView.panes.find(".pane").length).toBe 2
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 2

      atom.packages.deactivatePackage("preview-tabs")
      expect(atom.workspaceView.panes.find(".pane").length).toBe 2
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 0

    it "stops adding preview tabs views", ->
      atom.packages.deactivatePackage("preview-tabs")
      expect(atom.workspaceView.panes.find(".pane").length).toBe 1
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 0

      pane = atom.workspaceView.getActivePaneView()
      pane.splitRight(pane.copyActiveItem())
      expect(atom.workspaceView.panes.find(".pane").length).toBe 2
      expect(atom.workspaceView.panes.find(".pane > .preview-tabs").length).toBe 0

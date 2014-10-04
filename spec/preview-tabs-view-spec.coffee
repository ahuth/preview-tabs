{WorkspaceView}  = require "atom"
PreviewTabsView = require "../lib/preview-tabs-view"

describe "PreviewTabsView", ->
  previewTabsView = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    pane = atom.workspaceView.getActivePaneView()
    previewTabsView = new PreviewTabsView(pane)

  describe "removing", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsView.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsView.remove()
      expect(subscription.disposed).toBe true for subscription in subscriptions

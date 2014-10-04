{TextEditorView}  = require "atom"
PreviewTabsPreview = require "../lib/preview-tabs-preview"

describe "PreviewTabsPreview", ->
  previewTabsPreview = null
  editor = null

  beforeEach ->
    editor = new TextEditorView({}).getEditor()
    previewTabsPreview = new PreviewTabsPreview(editor, -> true)

  describe "destroying", ->
    subscriptions = null

    beforeEach ->
      subscriptions = []
      subscriptions.push subscription for own name, subscription of previewTabsPreview.subscriptions

    it "unsubscribes from its subscriptions", ->
      expect(subscription.disposed).toBe false for subscription in subscriptions
      previewTabsPreview.destroy()
      expect(subscription.disposed).toBe true for subscription in subscriptions

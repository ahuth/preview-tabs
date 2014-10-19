_ = require "underscore-plus"
PreviewTabsPaneView = require "./preview-tabs-pane-view"

# PreviewTabsPanesManager is responsible for adding/removing our preview tabs
# pane views to panes as they're created and destroyed.
module.exports =
class PreviewTabsPanesManager
  constructor: ->
    @previewTabsPaneViews = []
    @paneSubscription = atom.workspaceView.eachPaneView (paneView) =>
      previewTabsPaneView = new PreviewTabsPaneView(paneView)
      @previewTabsPaneViews.push(previewTabsPaneView)
      subscription = paneView.model.onDidDestroy =>
        _.remove(@previewTabsPaneViews, previewTabsPaneView)
        subscription.dispose()
      previewTabsPaneView

  destroy: ->
    @paneSubscription?.off()
    previewTabsPaneView.remove() for previewTabsPaneView in @previewTabsPaneViews
    @previewTabsPaneViews = []

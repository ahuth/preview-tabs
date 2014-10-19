_ = require "underscore-plus"
PreviewTabsView = require "./preview-tabs-view"

# PreviewTabsPanesManager is responsible for adding/removing our preview tabs
# views to panes as they're created and destroyed.
module.exports =
class PreviewTabsPanesManager
  constructor: ->
    @previewTabsViews = []
    @paneSubscription = atom.workspaceView.eachPaneView (paneView) =>
      previewTabsView = new PreviewTabsView(paneView)
      @previewTabsViews.push(previewTabsView)
      subscription = paneView.model.onDidDestroy =>
        _.remove(@previewTabsViews, previewTabsView)
        subscription.dispose()
      previewTabsView

  destroy: ->
    @paneSubscription?.off()
    previewTabsView.remove() for previewTabsView in @previewTabsViews
    @previewTabsViews = []

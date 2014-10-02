_ = require "underscore-plus"
PreviewTabsView = require "./preview-tabs-view"

module.exports =
  activate: (state) ->
    @paneSubscription = atom.workspaceView.eachPaneView (paneView) =>
      previewTabsView = new PreviewTabsView(paneView)
      @previewTabsViews ?= []
      @previewTabsViews.push(previewTabsView)
      subscription = paneView.model.onDidDestroy =>
        _.remove(@previewTabsViews, previewTabsView)
        subscription.dispose()
      previewTabsView

  deactivate: ->
    @paneSubscription?.off()
    previewTabsView.remove() for previewTabsView in @previewTabsViews
    @previewTabsViews = []

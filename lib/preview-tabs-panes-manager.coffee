_ = require "underscore-plus"
PreviewTabsPaneController = require "./preview-tabs-pane-controller"

# PreviewTabsPanesManager adds and removes pane controllers as panes are
# created and destroyed.
module.exports =
class PreviewTabsPanesManager
  constructor: ->
    @previewTabsPaneControllers = []
    @paneSubscription = atom.workspaceView.eachPaneView (paneView) =>
      previewTabsPaneController = new PreviewTabsPaneController(paneView)
      @previewTabsPaneControllers.push(previewTabsPaneController)
      subscription = paneView.model.onDidDestroy =>
        _.remove(@previewTabsPaneControllers, previewTabsPaneController)
        subscription.dispose()
      previewTabsPaneController

  destroy: ->
    @paneSubscription?.off()
    previewTabsPaneController.remove() for previewTabsPaneController in @previewTabsPaneControllers
    @previewTabsPaneControllers = []

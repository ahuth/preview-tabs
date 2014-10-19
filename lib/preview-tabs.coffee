PreviewTabsPanesManager = require "./preview-tabs-panes-manager"

module.exports =
  previewTabsPanesManager: null

  activate: (state) ->
    @previewTabsPanesManager = new PreviewTabsPanesManager(state.previewTabsState)

  deactivate: ->
    @previewTabsPanesManager.destroy()

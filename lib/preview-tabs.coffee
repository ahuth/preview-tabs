_ = require "underscore-plus"
PreviewTabsView = require "./preview-tabs-view"

module.exports =
  previewTabsView: null

  activate: (state) ->
    @previewTabsView = new PreviewTabsView(state.previewTabsViewState)

  deactivate: ->
    @previewTabsView.destroy()

  serialize: ->
    previewTabsViewState: @previewTabsView.serialize()

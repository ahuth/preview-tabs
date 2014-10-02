{View} = require "atom"

module.exports =
class PreviewTabsView extends View
  @content: ->
    @div class: "preview-tabs"

  initialize: (@pane) ->
    @pane.prepend(this)

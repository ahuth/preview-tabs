{View} = require "atom"

module.exports =
class PreviewTabsView extends View
  @content: ->
    @div class: "preview-tabs overlay from-top", =>
      @div "The PreviewTabs package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "preview-tabs:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "PreviewTabsView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)

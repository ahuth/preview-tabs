{WorkspaceView} = require "atom"
PreviewTabs = require "../lib/preview-tabs"

describe "PreviewTabs", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage("preview-tabs")

  it "can be activated", ->
    expect(atom.packages.isPackageActive("preview-tabs")).toBe true

  it "can be deactivated", ->
    atom.packages.deactivatePackages("preview-tabs")
    expect(atom.packages.isPackageActive("preview-tabs")).toBe false

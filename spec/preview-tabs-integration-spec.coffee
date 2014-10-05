{$, WorkspaceView}  = require "atom"

describe "PreviewTabs Integration Test", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspace = atom.workspaceView.model

    waitsForPromise -> atom.packages.activatePackage("tabs")
    waitsForPromise -> atom.packages.activatePackage("tree-view")
    waitsForPromise -> atom.packages.activatePackage("preview-tabs")

    waitsForPromise -> atom.workspace.open("sample1.js")
    waitsForPromise -> atom.project.open("sample2.js")
    waitsForPromise -> atom.project.open("sample3.js")

    runs ->
      atom.workspaceView.attachToDom()

  it "opens files as previews", ->
    [treeEntry1, treeEntry2, treeEntry3] = $(".tree-view .file")

    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    expect($(".pane").length).toBe 1

    treeEntry2.click()
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    expect($(".pane").length).toBe 1

    treeEntry3.click()
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    expect($(".pane").length).toBe 1

  it "keeps tabs when they're double clicked", ->
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    $(".tab.active").trigger "dblclick"
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe false

  it "keeps tabs when the file is saved", ->
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    editor = atom.workspaceView.getActivePaneItem()
    editor.save()
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe false

  it "keeps tabs when the files is modified", ->
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    editor = atom.workspaceView.getActivePaneItem()
    editor.setText("hello")
    editor.setText("world")
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe false

  it "keeps tabs when the tree entry is double clicked", ->
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe true
    treeEntry1 = $(".tree-view .file")[0]
    $(treeEntry1).trigger "dblclick"
    expect($(".tab.active").hasClass("preview-tabs-preview")).toBe false

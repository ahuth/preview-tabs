{WorkspaceView}  = require "atom"

describe "PreviewTabs Integration Test", ->
  treeView = null
  tabsView = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspace = atom.workspaceView.model

    waitsForPromise -> atom.packages.activatePackage("tabs")
    waitsForPromise -> atom.packages.activatePackage("tree-view")
    waitsForPromise -> atom.packages.activatePackage("preview-tabs")

    waitsForPromise -> atom.workspace.open("sample1.js")
    waitsForPromise -> atom.workspace.open("sample2.js")

    runs ->
      atom.workspaceView.attachToDom()
      treeView = atom.workspaceView.find(".tree-view").view()
      tabsView = atom.workspaceView.find(".tab-bar").view()

  it "opens files as previews", ->
    expect(tabsView.find(".tab").length).toBe 1
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
    expect(tabsView.find(".active .title").attr("data-name")).toBe "sample2.js"

    treeEntry1 = treeView.find(".name[data-name='sample1.js']")
    treeEntry1.click()
    waits(50)
    runs ->
      expect(tabsView.find(".tab").length).toBe 1
      expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
      expect(tabsView.find(".active .title").attr("data-name")).toBe "sample1.js"

  it "keeps tabs when they're double clicked", ->
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
    tabsView.find(".active").trigger "dblclick"
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe false

    treeEntry1 = treeView.find(".name[data-name='sample1.js']")
    treeEntry1.click()
    waits(50)
    runs ->
      expect(tabsView.find(".tab").length).toBe 2
      expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true

  it "keeps tabs when the file is saved", ->
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
    editor = atom.workspaceView.getActivePaneItem()
    editor.save()
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe false

  it "keeps tabs when the files is modified", ->
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
    editor = atom.workspaceView.getActivePaneItem()
    editor.setText("hello")
    editor.setText("hello world")
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe false

  it "keeps tabs when the tree entry is double clicked", ->
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe true
    treeEntry2 = treeView.find(".name[data-name='sample2.js']")
    treeEntry2.trigger "dblclick"
    expect(tabsView.find(".active").hasClass("preview-tabs-preview")).toBe false

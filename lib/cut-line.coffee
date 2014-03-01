module.exports =
  activate: ->
    atom.workspaceView.command "cut-line:cut-line", => @cutLine()
    atom.workspaceView.command "cut-line:copy-line", => @copyLine()

  cutLine: ->
    @selectLine()
    @currentSelection().cut()

  copyLine: ->
    @selectLine()
    @currentSelection().copy()

  selectLine: ->
    if @currentSelection().getText().length == 0
      atom.workspace.activePaneItem.selectLine()

  currentSelection: ->
    return atom.workspace.getActiveEditor().getSelection()

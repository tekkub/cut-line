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
    if @prevPos
      atom.workspace.getActiveEditor().getCursor().clearSelection()
      atom.workspace.getActiveEditor().getCursor().setBufferPosition(@prevPos)

  selectLine: ->
    if @currentSelection().getText().length == 0
      @prevPos = atom.workspace.getActiveEditor().getCursor().getBufferPosition()
      atom.workspace.activePaneItem.selectLine()

  currentSelection: ->
    return atom.workspace.getActiveEditor().getSelection()

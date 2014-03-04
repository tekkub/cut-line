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
      @editor.getCursor().clearSelection()
      @editor.getCursor().setBufferPosition(@prevPos)

  selectLine: ->
    @prevPos = null
    @editor = atom.workspace.getActiveEditor()
    if @currentSelection().getText().length == 0
      @prevPos = @editor.getCursor().getBufferPosition()
      atom.workspace.activePaneItem.selectLine()

  currentSelection: ->
    return @editor.getSelection()

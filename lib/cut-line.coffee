module.exports =
  activate: ->
    atom.workspaceView.command "cut-line:cut-line", => @cutLine()
    atom.workspaceView.command "cut-line:copy-line", => @copyLine()

  cutLine: ->
    @selectLine()
    @editor.cutSelectedText()

  copyLine: ->
    @selectLine()
    @editor.copySelectedText()
    if @prevPos
      for cursor in @prevPos
        cursor[0].clearSelection()
        cursor[0].setBufferPosition(cursor[1])

  selectLine: ->
    @prevPos = null
    @editor = atom.workspace.getActiveEditor()
    cursors = @editor.getCursors()
    if @selectionsAreEmpty()
      @prevPos = ([cursor, cursor.getBufferPosition()] for cursor in cursors)
      @editor.selectLine()

  selectionsAreEmpty: ->
    for selection in @editor.getSelections()
      return false unless selection.isEmpty()
    true

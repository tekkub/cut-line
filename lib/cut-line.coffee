module.exports =
  activate: ->
    atom.workspaceView.command "cut-line:cut-line", => @cutLine()
    atom.workspaceView.command "cut-line:copy-line", => @copyLine()
    atom.workspaceView.command "cut-line:paste-line", => @pasteLine()

  cutLine: ->
    fullline = @selectLine()
    @editor.cutSelectedText()
    if fullline
      atom.clipboard.metadata = atom.clipboard.metadata || {}
      atom.clipboard.metadata.fullline = true

  copyLine: ->
    fullline = @selectLine()
    @editor.copySelectedText()
    if fullline
      atom.clipboard.metadata = atom.clipboard.metadata || {}
      atom.clipboard.metadata.fullline = true
    if @prevPos
      for cursor in @prevPos
        cursor[0].clearSelection()
        cursor[0].setBufferPosition(cursor[1])

  pasteLine: ->
    clipContents = atom.clipboard.readWithMetadata();
    if clipContents.metadata && clipContents.metadata.fullline
      @editor.moveCursorToBeginningOfLine()
      @editor.insertNewlineAbove()
      cursors = @editor.getCursors()
      cursors = cursors.sort (a,b) -> return if a.getBufferRow() > b.getBufferRow() then 1 else -1
      clipLines = clipContents.text.split("\n")
      clipLines = clipLines.filter (elm) ->
        return elm != ""
      selections = @editor.getSelectionsOrderedByBufferPosition()
      if selections.length == 1
        for line, i in clipLines
          if i < clipLines.length-1
            selections[0].insertText(line+"\n")
          else
            selections[0].insertText(line)
      else
        for selection, i in selections
          selection.insertText(clipLines[i] || clipLines[i%clipLines.length])
    else
      @editor.pasteText();

  selectLine: ->
    @prevPos = null
    @editor = atom.workspace.getActiveEditor()
    cursors = @editor.getCursors()
    if @selectionsAreEmpty()
      @prevPos = ([cursor, cursor.getBufferPosition()] for cursor in cursors)
      @editor.selectLine()
      @editor.selections = @editor.getSelectionsOrderedByBufferPosition()
      return true;

  selectionsAreEmpty: ->
    for selection in @editor.getSelections()
      return false unless selection.isEmpty()
    true
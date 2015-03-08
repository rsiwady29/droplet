readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText

require.config
  baseUrl: '../js'
  paths: JSON.parse readFile '../requirejs-paths.json'

require ['droplet'], (droplet) ->

  # Example palette
  window.editor = new droplet.Editor document.getElementById('editor'), {
    # JAVASCRIPT TESTING:
    mode: 'csv'
    palette: [
      {
        name: 'Numbers'
        color: 'blue'
        blocks: [
          {block:'0,1,2,3,4', title: 'First 5'}
        ]
      },
      {
        name: 'Names'
        color: 'violet'
        blocks: [
          {block:'Richard,David,Albert', title: 'Male'}
          {block:'Dania,Jessica,Karen', title: 'Female'}
        ]
      },
      {
        name: 'Assistance'
        color: 'violet'
        blocks: [
          {block:'<last-name>,<first-name>,<email>', title: 'Template'}
        ]
      }
    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    oneline: '''
    Richard,Siwady,Honduras
    '''
    multiplelines: '''
    monday,4.0,frank
    tuesday,2.3,sally
    wednesday,1.8,carol
    '''
    controller: readFile '../src/controller.coffee'
    compiler: readFile '../test/data/nodes.coffee'
    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  startingText = localStorage.getItem 'example'
  editor.setValue startingText or examplePrograms.fizzbuzz

  # Update textarea on ICE editor change
  onChange = ->
    localStorage.setItem 'example', editor.getValue()

  editor.on 'change', onChange

  editor.aceEditor.on 'change', onChange

  # Trigger immediately
  do onChange

  document.getElementById('which_example').addEventListener 'change', ->
    console.log @value
    editor.setValue examplePrograms[@value]

  editor.clearUndoStack()

  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    editor.toggleBlocks()

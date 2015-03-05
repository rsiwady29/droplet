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

    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    fizzbuzz: '''
    monday,4.0,frank
    '''
    quicksort: '''
    globalNumberOfComparisons = 0
    bubblesort = (list) ->
      for _ in [1..list.length]
        for item, i in list
          globalNumberOfComparisons += 1
          if list[i] > list[i+1]
            temp = list[i]
            list[i] = list[i + 1]
            list[i + 1] = temp
      return list
    quicksort = ([head,tail...]) ->
      return [] unless head?
      globalNumberOfComparisons += 1 + tail.length
      smaller_sorted = quicksort (e for e in tail when e <= head)
      larger_sorted = quicksort (e for e in tail when e > head)
      return smaller_sorted.concat([head]).concat(larger_sorted)
    array = [1..1000]
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    quicksort array
    quicksortSpeed = globalNumberOfComparisons
    see 'Quicksort finished in ' + globalNumberOfComparisons + ' operations'
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    globalNumberOfComparisons = 0
    bubblesort array
    see 'Bubblesort finished in ' + globalNumberOfComparisons + ' operations'
    see 'Quicksort was ' + globalNumberOfComparisons / quicksortSpeed + ' times faster'
    '''
    church: '''
    zero = (f) -> (x) -> x
    church = (n) ->
      if n > 0
        return succ church n-1
      return zero
    unchurch = (n) -> n((x) -> x + 1) 0
    succ = (n) -> (f) -> (x) -> f n(f) x
    add = (m, n) -> (f) -> (x) -> m(f) n(f) x
    mult = (m, n) -> (f) -> n m f
    exp = (m, n) -> n m
    pred = (n) -> (f) -> (x) -> n((g) -> (h) -> h(g(f)))(->x)((u)->u)
    sub = (m, n) -> n(pred) m
    see unchurch exp church(2), church(6)
    see unchurch add church(3), church(10)
    see unchurch sub church(10), church(3)
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

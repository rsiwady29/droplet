define ['droplet-helper', 'droplet-parser'], (helper, parser) ->
	class csv extends parser.Parser    
    	markRoot: ->
    		@lines = @text.split '\n'
    		lineNumber = 0
    		for line in @lines
    			if !line
    				continue
    			column = 0;
	    		@addBlock({
	    			bounds: {
	    				start: {line: lineNumber, column: column}
	    				end: {line: lineNumber, column: line.length}
	    			}
	    			depth: 1
	    			color: 'violet'
				})

	    		@values = line.split ','
	    		for value in @values
	    			@addSocket({
	    				bounds:{
    						start:{line: lineNumber, column: column}
    						end: {line:lineNumber, column: column + value.length}
	    				}
	    				depth: 2 
    				})
    				column += value.length + 1
	    		lineNumber++
			
	return parser.wrapParser csv
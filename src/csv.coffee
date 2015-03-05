define ['droplet-helper', 'droplet-parser'], (helper, parser) ->
	class csv extends parser.Parser    
    	markRoot: ->
    		@lines = @text.split '\n'
    		index = 1
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
	    			depth: index
	    			color: 'violet'
				})

	    		@values = line.split ','
	    		for value in @values
	    			console.log index
	    			@addSocket({
	    				bounds:{
    						start:{line: lineNumber, column: column}
    						end: {line:lineNumber, column: column + value.length}
	    				}
	    				depth: index 
    				})
    				column = column + value.length + 1
	    		index = index + 1
	    		lineNumber = lineNumber + 1
			
	return parser.wrapParser csv
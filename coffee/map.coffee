define ['astar', 'utils'], (AStar, Utils) ->

	class Map

		constructor: ->
			@blankGrid = []
			@generateBlankGrid()
			@blocking = null

			##
			setInterval(=>
				Utils.removeDebugEntities('permissions')
				for x in [0...29]
					for y in [0...18]
						if @isTileBlocking(x, y)
							Utils.createDebugEntity(x, y, 'red', -1, 'permissions')
			, 40)
			##

		generateBlankGrid: ->
			for y in [0...18]
				@blankGrid[y] = []
				for x in [0...29]
					@blankGrid[y][x] = 0
		
		setBlockingGrid: (grid) ->
			@blocking = grid

		getFreeTiles: ->
			freeTiles = []
			for x in [0...29]
				for y in [0...18]
					freeTiles.push([x, y])
			return freeTiles

		# Parcourir en spirale et chercher la tile libre la plus proche
		getNearestFreeTile: (x, y) ->
			defaultPos = [x, y] # reserved word
			length = 1
			i = 0
			while 1
				for j in [0...length]
					dir = [[1, 0], [0, -1], [-1, 0], [0, 1]][i%4]
					x += dir[0]
					y += dir[1]
					if !@isTileOut(x, y) && !@isTileBlocking(x, y)
						return [x, y]
				i++
				if(i%2 == 0)
					length++
				if(length > 29)
					return defaultPos
						
		isTileOut: (x, y) ->
			return !(x >= 0 and x < 29 and y >= 0 and y < 18)

		isTileBlocking: (x, y) ->
			return @blocking[y] && @blocking[y][x] == 1

		isTileFree: (x, y) ->
			return !@isTileOut(x, y) and !@isTileBlocking(x, y)

		addBlockingItem: (x, y, width = 1, height = 1) ->
			for i in [x...x + width]
				for j in [y...y + height]
					@blocking[j][i] = 1

		removeBlockingItem: (x, y, width = 1, height = 1) ->
			for i in [x...x + width]
				for j in [y...y + height]
					@blocking[j][i] = 0

		getDistance: (start, goal) ->
			return @findPath(start, goal).length

		findPath: (start, goal, grid = @blocking) ->
			return AStar(grid, start, goal, "Manhattan")

		findIncompletePath: (start, goal) -> # À tester
			perfectPath = @findPath(start, goal, @blankGrid)
			incompletePath = [] # On met déjà le premier pas, qu'il soit bloqué ou non.
			console.log "perfectpath:"
			console.log JSON.stringify perfectPath

			for i in [0...perfectPath.length] # Du coup, on commence à l'index 1 et non 0
				step = perfectPath[i]
				if @isTileBlocking(step[0], step[1]) and i != 0
					console.log "troubleshoot final, return incompletePath : "
					console.log JSON.stringify incompletePath
					return incompletePath
				else 
					incompletePath.push(JSON.parse(JSON.stringify step))
					console.log "troubleshoot initial : "
					console.log JSON.stringify incompletePath

			return incompletePath
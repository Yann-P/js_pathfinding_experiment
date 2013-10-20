define ['astar'], (AStar) ->

	class Map

		constructor: ->
			@blocking = null
		
		setBlockingGrid: (grid) ->
			@blocking = grid

		getFreeTiles: ->
			freeTiles = []
			for x in [0...29]
				for y in [0...18]
					freeTiles.push([x, y])
			return freeTiles

		getNearestFreeTile: (x, y) ->
			if(@getFreeTiles().length == 0) # Éviter une boucle infinie : si il n'y a plus de place sur la map, go en 0,0
				alert "Oh noes" ## Ne s'exécute jamais ?!!!!
				return [0, 0]

			# Parcourir en spirale et chercher la tile libre la plus proche
			directions = [[1, 0], [0, -1], [-1, 0], [0, 1]]
			length = 1
			i = 0
			loop
				for j in [0...length]
					dir = directions[i%4]
					x += dir[0]
					y += dir[1]
					
					if !@isTileOut(x, y) && !@isTileBlocking(x, y)
						return [x, y]
				i++
				if(i%2 == 0)
					length++

				if(length > 29)
					return [0, 0]



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

		findPath: (start, goal)->
			return AStar(@blocking, start, goal, "Manhattan")

		findIncompletePath: ->





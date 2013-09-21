define ['lib/jquery', 'lib/astar', 'data', 'zombie'], ($, AStar, Data, Zombie) ->

	class Level

		constructor: (id, app) ->
			@id = id
			@app = app
			@entityCount = 0
			@zombies = {}

			data = Data.store.levels[@id]
			@name = data.name
			@blocking = data.map.blocking
			@gold = data.initialGold
			@backgroundPath = "resources/img/maps/#{@name}.png"
			@loadMap()
			##
			@addZombie()
			##

		loadMap: ->
			document.getElementById('game').style.backgroundImage = "url('#{@backgroundPath}')"

		addZombie: ->
			setInterval(=>
				zombie = @zombies[@entityCount] = new Zombie(@entityCount, 'zombie_weak')
				zombie.setPosition(Math.floor(Math.random() * 29), Math.floor(Math.random() * 18))
				@entityCount++

				path = AStar(@blocking, [zombie.x, zombie.y], [13, 9], "Manhattan")
				zombie.setMoveStack(path)
				setTimeout(=>
					zombie.remove()
				, 10000)
			, 250)
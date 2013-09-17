define ['lib/jquery', 'data', 'types', 'zombie'], ($, Data, Types, Zombie) ->

	class Game

		constructor: (level, app) ->
			@level = level
			@app = app
			@entityCount = 0
			@zombies = {}

			data = Data.store.levels[@level]
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

			zombie = @zombies[@entityCount] = new Zombie(@entityCount, Types.Zombies.WEAK)
			zombie.setPosition(1, 1, true)
			zombie.sprite.setAnimation('move_up')
			@entityCount++
			zombie.setMoveStack([[1, 1], [2, 1], [2, 2], [2, 3], [3, 3]])
			
			

		

	return Game


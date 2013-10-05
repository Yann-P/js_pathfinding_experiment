define ['lib/jquery', 'lib/astar', 'data', 'utils', 'zombie', 'wave'], ($, AStar, Data, Utils, Zombie, Wave) ->

	class Level

		constructor: (id, app) ->
			@id = id
			@app = app
			@entityCount = 0
			@entities = {}
			@currentWaveId = 0
			@waves = []
			@setup()
			## x = Math.floor((event.clientX - $('#game').position().left) / 32)

		setup: ->
			data = Data.store.levels[@id]
			{ @name, @gold, @blocking } = data
			@background = "resources/img/maps/#{@name}.png"
			@wavesData = data.waves
			@loadMap()
			@addWaves()
			@nextWave()

		# Préparer le vagues sous forme d'instances de Wave dans @waves
		addWaves: ->
			for waveData in @wavesData
				id = @waves.length
				wave = new Wave(id, waveData.zombies, waveData.interval, waveData.next, @)
				@waves[id] = wave

		nextWave: ->
			@waves[@currentWaveId].start(=>
				if @currentWaveId < @waves.length
					@nextWave()
				else console.log "Toutes vagues envoyées"
			)
			@currentWaveId++

		# Ajouter un zombie de type kind à x, y
		addZombie: (x, y, kind) ->
			id = @entityCount++
			zombie = new Zombie(id, kind)
			zombie.setPosition(x, y)
			@addCharacterCallback(zombie)
			return zombie


		addCharacterCallback: (character) ->
			@entities[character.id] = character
			character.enableSmoothMvmt()
			character.onRequestedPath((x, y) =>
				return @findPath(character, x, y)
			)
			character.onDeath( =>
				character.remove()
				delete @entities[character.id]
			)


		findPath: (character, x, y) ->
			path = AStar(@blocking, [character.x, character.y], [x, y], "Manhattan")
			if path.length is 0
				console.log("Le personnage ##{character.id} de type #{character.kind} n'a pas trouvé de chemin jusque (#{x}, #{y})")
			return path

		loadMap: ->
			$('#game').css('backgroundImage', "url('#{@background}')")
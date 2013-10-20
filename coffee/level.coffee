define ['jquery', 'astar', 'data', 'utils', 'map', 'zombie', 'villager', 'tower', 'effect', 'wave', 'entity'], ($, AStar, Data, Utils, Map, Zombie, Villager, Tower, Effect, Wave, Entity) ->

	class Level

		constructor: (id, app) ->
			@id = id
			@app = app
			@entityCount = 0
			@entities = {}
			@currentWaveId = 0
			@waves = []
			@map = new Map()

			@setup()

			## EXPERIMENT ZONE
				# x = Math.floor((event.clientX - $('#game').position().left) / 32)
				# ~~(Math.random() * 20)
			
				#@effectAt('attack2', 0, 0)
			##
			
		setup: ->
			data = Data.store.levels[@id] or throw "Données manquantes pour level ##{@id}"
			{ @name, @gold, @blocking, @initialTowers } = data

			$('#game').css('backgroundImage', "url('resources/img/maps/#{@name}.png')")
			@wavesData = data.waves
			@addWaves()
			@map.setBlockingGrid(@blocking)
			@addInitialTowers()
			@nextWave()

		addInitialTowers: ->
			tower = null
			for towerData in @initialTowers
				tower = @addTower(towerData.x, towerData.y, towerData.kind)
				tower.setUpgradeLevel(towerData.upgradeLevel or 0)

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

		createAttackLink: (attacker, target) ->
			attacker.setTarget(target)
			attacker.follow(target)
			target.addAttacker(attacker)
			
		effectAt: (effectid, x, y) ->
			effect = new Effect(@entityCount++, effectid, false)
			@entities[effect.id] = effect
			effect.playAt(x, y, =>
				@removeEntity(@entities[effect.id])
			)

		addZombie: (x, y, kind) ->
			zombie = new Zombie(@entityCount++, kind)
			zombie.setPosition(x, y)
			@addCharacterCallback(zombie)

			return zombie

		addVillager: (x, y, kind) ->
			villager = new Villager(@entityCount++, kind)
			villager.setPosition(x, y)
			@addCharacterCallback(villager)
			return villager

		addTower: (x, y, kind) ->
			tower = new Tower(@entityCount++, kind)
			tower.setPosition(x, y)
			@map.addBlockingItem(tower.x, tower.y, tower.width, tower.height)
			tower.onRemove( =>
				@map.removeBlockingItem(tower.x, tower.y, tower.width, tower.height)
			)

			# Ajouter la porte
			door = new Entity(@entityCount++, tower.door.spriteid)
			door.setPosition(tower.x + tower.door.x, tower.y + tower.door.y)
			door.setAnimation('opening', 1)

			# Ajouter les villageois
			for type, amount of tower.villagers
				for i in [0...amount]
					@addVillager(door.x, door.y, type)

			return tower


		addCharacterCallback: (character) ->
			@entities[character.id] = character
			character.enableSmoothMvmt()

			if !@map.isTileFree(character.x, character.y)
				pos = @map.getNearestFreeTile(character.x, character.y)
				character.setPosition(pos[0], pos[1])

			@map.addBlockingItem(character.x, character.y)

			character.onStep( =>
				character.forEachAttacker( (attacker) =>
					attacker.follow(character)
				)
			)
			character.onRequestedPath((x, y) =>
				return @findPath(character, x, y)
			)
			character.onDeath( =>
				@removeEntity(character)
			)

		removeEntity: (entity) ->
			console.log "remove:"
			console.log entity
			entity.remove()
			delete @entities[entity.id]

		getAllZombies: ->
			zombies = {}
			for id of @entities
				if @entities[id] instanceof Zombie
					zombies[id] = @entities[id]
			return zombies

		findPath: (character, x, y) ->
			path = @map.findPath([character.x, character.y], [x, y])
			if path.length is 0
				console.log("Le personnage ##{character.id} de type #{character.kind} n'a pas trouvé de chemin jusque (#{x}, #{y})")
			return path
			

		destroy: ->
			for entity of @entities
				@removeEntity[entity]
			@waves[@currentWaveId].stop()

	return Level
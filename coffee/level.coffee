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
			v1 = @addVillager(5, 1, 'villager_1')
			#v2 = @addVillager(0, 1, 'villager_2')
			#v3 = @addVillager(0, 1, 'villager_3')
			v1.moveTo(18, 1)
			#v2.moveTo(18, 1)
			#v3.moveTo(18, 1)
			#@effectAt('attack2', 0, 0)

			##
			
		setup: ->
			data = Data.store.levels[@id] or throw "Données manquantes pour level ##{@id}"
			{ @name, @gold, @blocking, @initialTowers } = data

			## $('#game').css('backgroundImage', "url('resources/img/maps/#{@name}.png')")
			$('#game').css('background', "lightyellow") ##
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
					tvill = @addVillager(door.x, door.y, type) ##
					console.log tvill.x + ' ' + tvill.y
					tvill.moveTo(0, 0) ##
			return tower

		addCharacterCallback: (character) ->
			@entities[character.id] = character
			character.enableSmoothMvmt()

			if !@map.isTileFree(character.x, character.y)
				console.log "Un personnage a spawné dans un mur"
				pos = @map.getNearestFreeTile(character.x, character.y)
				character.setPosition(pos[0], pos[1])

			@map.addBlockingItem(character.x, character.y)

			character.onBeforeNextStep( (nextX, nextY) =>
				##Utils.createDebugEntity(nextX, nextY, 'green', 100)
				
				console.log "$ beforeNextStep : actuellement en (#{character.x}, #{character.y}), prochaine case (#{nextX}, #{nextY})"
				if not @map.isTileFree(nextX, nextY) ##
					console.log("# Bloqué à (#{character.x}, #{character.y}), ne peut pas se rendre en (#{nextX}, #{nextY})") ##
					
					character.abortMove()
					console.log "#######"
					character.moveTo(18, 1)


					#character.recalculatePath()

				# Debug du path
				Utils.removeDebugEntities('path' + character.id)
				for coord in character.moveStack
					Utils.createDebugEntity(coord[0], coord[1], 'blue', -1, 'path' + character.id)

			)
			character.onStep( (prevX, prevY) =>
				@map.removeBlockingItem(prevX, prevY)
				@map.addBlockingItem(character.x, character.y)

				console.log "$ step : passage de (#{prevX}, #{prevY}) à (#{character.x}, #{character.y})"
				character.forEachAttacker( (attacker) =>
					attacker.follow(character)
				)
				##
				if character.x == 6
					@map.addBlockingItem(character.x + 2, character.y)
				##

			)
			character.onRequestedPath((x, y) =>
				path = @findPath(character, x, y)
				return path
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
				path = @map.findIncompletePath([character.x, character.y], [x, y])
				if path.length is 0
					console.log("Le personnage ##{character.id} de type #{character.kind} n'a pas trouvé de chemin jusque (#{x}, #{y})")
				else
					console.log "Chemin incomplet"
					console.log JSON.parse(JSON.stringify(path)).length

					console.log JSON.stringify path
					console.log path.length
					console.log path
					console.log "1re entrée : " + path[0]
					console.log "/chemin incomplet"
					
			return path
			

		destroy: ->
			for entity of @entities
				@removeEntity[entity]
			@waves[@currentWaveId].stop()

	return Level
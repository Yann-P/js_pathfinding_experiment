define [], () ->

	class Wave

		constructor: (id, zombiesList, interval, next, level) ->
			@id = id
			@zombiesList = zombiesList  # Sous la forme { "type1": 2, "type2": 1, ... }
			@interval = interval		# Temps entre 2 zombies
			@next = next or 0 			# Temps en sec avant d'exécuter le callback
			@level = level
			@nextZombieTimeout = null
			@callback = null

		# Lancer une vague
		start: (callback) ->
			@callback = callback
			@stack = [] 					   # Liste de zombies à spawner
			for zombieType, nb of @zombiesList # Transforme zombieList sous la forme ["type1", "type1", "type2"]
				for i in [0...nb]
					@stack.push(zombieType)
			console.log("Vague ##{@id} commencée (#{@stack.length} zombies)")
			@tick()

		# Envoyer le prochain zombie.
		tick: ->
			if @stack.length == 0 		# Si c'est fini pour cette vague
				console.log("Vague ##{@id} terminée. #{@next}s avant prochaine")
				return setTimeout( =>
					console.log("Temps écoulé")
					@callback()
				, @next * 1000)

			zombie = @level.addZombie(14, 17, @stack[0])
			zombie.moveTo(Math.floor(Math.random() * 29), Math.floor(Math.random() * 18))
			@stack.splice(0, 1) 		# On enlève le zombie de la liste à spawner

			@nextZombieTimeout = setTimeout( =>
				@tick()
			, @interval * 1000)

		stop: ->
			clearTimeout(@nextZombieTimeout)
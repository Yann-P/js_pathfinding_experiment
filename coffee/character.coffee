define ['jquery', 'utils', 'data', 'entity'], ($, Utils, Data, Entity) ->

	class Character extends Entity

		constructor: (id, kind) ->
			@moveStack = []
			@orientation = 'down'
			@requestedPathCallback = null
			@beforeNextStepCallback = null
			@stepCallback = null
			@deathCallback = null
			@currentMoveTimeout = null
			@mvmtInProgress = false
			@target = null
			@attackers = {}
			super(id, kind)
			@setup() ## Attention à ne pas écraser

		setup: ->
			@healthBar = healthBar = document.createElement('div')
			$(healthBar).addClass('health-bar')
			$(@elt)
				.addClass('character')
				.append(healthBar)
			@setAnimation('idle_down')

		follow: (character) ->
			@moveTo(character.x, character.y)

		recalculatePath: ->
			console.log "Recalcul du chemin"
			if @moveStack.length == 0
				throw "Impossible de recalculer le chemin. Aucun mvmt en cours."
			# Le dernier élément de movestack est la destination du mvmt en cours.
			destination = @moveStack[@moveStack.length - 1]
			@moveTo(destination[0], destination[1])

		setTarget: (character) ->
			if @target
				@removeTarget()
			@target = character

		removeTarget: ->
			@target = null
			@abortMove()

		addAttacker: (character) ->
			console.log @attackers
			if !(character.id in @attackers)
				@attackers[character.id] = character
			else throw 'Déjà attaqué par ce personnage'

		removeAttacker: (character) ->
			if character.id in @attackers
				delete @attackers[character.id]
			else throw 'Pas attaqué par ce personnage'
			
		forEachAttacker: (callback) ->
			for id of @attackers
				callback(@attackers[id])

		damage: (hp) ->
			@health -= hp
			if @health <= 0
				@hp = 0
				return @die()
			@updateHealthBar()

		heal: (hp) ->
			@health += hp
			if @health > @maxHealth
				@health = @maxHealth
			@updateHealthBar()

		updateHealthBar: ->
			$(@healthBar).css('background', 'white')
			setTimeout( =>
				$(@healthBar).css({
					background: 'red'
					width: (@health / @maxHealth) * 30
				})
			, 100)

		die: ->
			@onDeathCallback()

		# Définit une pile de mouvements à effectuer. Sous la forme [[y0, y0], [x1, y1], ...[xDest, yDest]] où x0 et y0 sont la pos actuelle
		setMoveStack: (moveStack) ->
			console.log "Setmovestack avec (#{moveStack[0][0]}, #{moveStack[0][1]}) comme source"
			@moveStack = moveStack
			if not @mvmtInProgress
				console.log "Pas de mouvement en cours, nextMove()"
				@_nextMove()

		abortMove: ->
			console.log "AbortMove en (#{@x}, #{@y}). Timeout cleared : "+@currentMoveTimeout
			window.clearTimeout(@currentMoveTimeout)
			@moveStack = []

		# Effectue concrètement le passage d'une case à l'autre, puis exécute le callback avec un retard équivalent à la vitesse
		move: (x, y, callback) ->
			@setPosition(x, y)
			@currentMoveTimeout = window.setTimeout( =>
				console.log("Timeout just executed : " + @currentMoveTimeout)
				callback()
			, 1000) ##(1000 / @speed)
			console.log "Timeout just set : " + @currentMoveTimeout

		# Aller à (x, y) en utilisant le pathfinder
		moveTo: (x, y) ->
			console.log "MoveTo depuis (#{@x}, #{@y}) jsq (#{x}, #{y})"
			path = @requestedPathCallback(x, y)
			@setMoveStack(path)

		# Se déplacer dans une direction
		moveTowards: (direction, callback) ->
			pos = { x: @x, y: @y }
			switch direction
				when 'left' 	then pos.x--
				when 'right' 	then pos.x++
				when 'up' 		then pos.y--
				when 'down' 	then pos.y++

			@setAnimation("move_#{direction}") 
			@orientation = direction
			@mvmtInProgress = true
			@move(pos.x, pos.y, =>
				@mvmtInProgress = false
				callback()
			)

		# Exécute un mouvement du moveStack.
		_nextMove: ->
			if @moveStack.length <= 1 # Plus aucun déplacement à faire, on passe en idle et on quitte
				return @idle()

			source = @moveStack[0]
			dest = @moveStack[1]

			console.log "NextMove. moveStack actuel : " + JSON.stringify @moveStack

			direction = null
			if source[0] != @x or source[1] != @y
				throw "La source (#{source[0]}, #{source[1]}) n'est pas la position actuelle du Character (#{@x}, #{@y})"
			if Math.abs(source[0] - dest[0]) + Math.abs(source[1] - dest[1]) > 1
				throw "Il doit y avoir exactement une coordonnée changée de source à dest, x OU y"
			# Déduire la direction entre la source et la destination
			if 		source[0] - dest[0] == -1 	then direction = 'right'	# x+
			else if source[0] - dest[0] ==  1 	then direction = 'left' 	# x-
			else if source[1] - dest[1] == -1   then direction = 'down' 	# y+	
			else if source[1] - dest[1] ==  1   then direction = 'up' 		# y-
			else throw "Mouvement inconnu"	
			
			
			@moveTowards(direction, =>
				@beforeNextStepCallback(@moveStack[1][0], @moveStack[1][1]) # nextX, nextY
				@_nextMove()
			)
			@stepCallback(source[0], source[1]) # prevX, prevY
			
			@moveStack.splice(0, 1) # On enlève le 1er élément du moveStack

		# Activer le mouvement fluide avec CSS3
		enableSmoothMvmt: ->
			$(@elt).addClass('smooth-mvmt')
			Utils.setTransitionDuration(@elt, 1 / @speed)
			window.getComputedStyle(@elt).getPropertyValue("left");

		disableSmoothMvmt: ->
			$(@elt).removeClass('smooth-mvmt')

		onRequestedPath: (callback) ->
			@requestedPathCallback = callback

		onBeforeNextStep: (callback) ->
			@beforeNextStepCallback = callback

		onStep: (callback) ->
			@stepCallback = callback

		onDeath: (callback) ->
			@onDeathCallback = callback

		idle: ->
		    console.log "idle"
		    @setAnimation("idle_#{@orientation}")

		remove: -> # Écrase le remove() de Entity, qu'on appelle avec un .call() sur le prototype d'Entity
			console.log "Remove character"
			@abortMove()
			Entity.prototype.remove.call(@) # Parent::remove()
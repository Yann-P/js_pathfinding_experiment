define ['jquery', 'utils', 'data', 'entity'], ($, Utils, Data, Entity) ->

	class Character extends Entity

		constructor: (id, kind) ->
			@moveStack = []
			@orientation = 'down'
			@requestedPathCallback = null
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
			@moveStack = moveStack
			if not @mvmtInProgress
				@_nextMove()

		abortMove: ->
			clearTimeout(@currentMoveTimeout)
			@moveStack = []

		# Effectue concrètement le passage d'une case à l'autre, avec un retard équivalent à la vitesse
		move: (x, y, callback) ->
			@stepCallback()
			@setPosition(x, y)
			@currentMoveTimeout = setTimeout( =>
				callback()
				
			, (1000 / @speed))

		# Aller à (x, y) en utilisant le pathfinder
		moveTo: (x, y) ->
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

		# Activer le mouvement fluide avec CSS3
		enableSmoothMvmt: ->
			$(@elt).addClass('smooth-mvmt')
			Utils.setTransitionDuration(@elt, 1 / @speed)
			window.getComputedStyle(@elt).getPropertyValue("left");

		disableSmoothMvmt: ->
			$(@elt).removeClass('smooth-mvmt')

		onRequestedPath: (callback) ->
			@requestedPathCallback = callback

		onStep: (callback) ->
			@stepCallback = callback

		onDeath: (callback) ->
			@onDeathCallback = callback

		idle: ->
		    @setAnimation("idle_#{@orientation}")

		# Exécute un mouvement du moveStack.
		_nextMove: ->
			if @moveStack.length <= 1 # Plus aucun déplacement à faire, on passe en idle et on quitte
				return @idle()

			source = @moveStack[0]
			dest = @moveStack[1]
			direction = null
			if source[0] != @x or source[1] != @y
				throw "La source n'est pas la position actuelle du Character"

			if Math.abs(source[0] - dest[0]) + Math.abs(source[1] - dest[1]) > 1
				throw "Il doit y avoir exactement une coordonnée changée de source à dest, x OU y"

			# Déduire la direction entre la source et la destination
			if 		source[0] - dest[0] == -1 	then direction = 'right' # x+
			else if source[0] - dest[0] ==  1 	then direction = 'left' # x-
			else if source[1] - dest[1] == -1   then direction = 'down' # y+	
			else if source[1] - dest[1] ==  1   then direction = 'up' # y-
			else throw "Mouvement inconnu"

			@moveTowards(direction, =>
				@_nextMove()
			)
			@moveStack.splice(0, 1) # On enlève le 1er élément du moveStack

		remove: -> # Écrase le remove() de Entity, qu'on appelle avec un .call() sur le prototype d'Entity
			console.log "Remove character"
			@abortMove()
			Entity.prototype.remove.call(@) # Parent::remove()
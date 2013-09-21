define ['lib/jquery', 'data', 'entity'], ($, Data, Entity) ->

	class Character extends Entity

		constructor: (id, kind) ->
			@moveStack = []
			@orientation = 'down'
			super(id, kind)

			$(@elt).addClass('character')
			@enableSmoothMvmt()
			@disableSmoothMvmt()

		setMoveStack: (moveStack) ->
			@moveStack = moveStack
			@nextMove()

		move: (x, y, callback) ->
			
			@setPosition(x, y) # Pouqquoi remplacer setPos par teleport ne les fait pas bouger de manière saccadée ?! tester disableSmoothMvt
			setTimeout( =>
				callback()
			, (1000 / @speed))

		"""teleport: (x, y) ->
			@disableSmoothMvmt()
			@setPosition(x, y)
			@enableSmoothMvmt()"""

		nextMove: ->
			return unless @moveStack.length > 1
			source = @moveStack[0]
			dest = @moveStack[1]
			direction = null
			if source[0] != @x or source[1] != @y
				throw "Source isn't current character position"

			if Math.abs(source[0] - dest[0]) + Math.abs(source[1] - dest[1]) > 1
				throw "There must be exactly one coordinate change between source and dest"

			# Déplacement
			if source[0] - dest[0] == -1
				direction = 'right' # x+
			else if source[0] - dest[0] == 1
			    direction = 'left' # x-
			else if source[1] - dest[1] == -1
				direction = 'down' # y+	
			else if source[1] - dest[1] == 1
				direction = 'up' # y-
			else throw "Impossible move"

			@moveTowards(direction, =>
				@nextMove()
			)
			@moveStack.splice(0, 1) # On enlève le 1er élément du moveStack

		moveTowards: (direction, callback) ->
			pos = { x: @x, y: @y }
			switch direction
				when 'left' 	then pos.x--
				when 'right' 	then pos.x++
				when 'up' 		then pos.y--
				when 'down' 	then pos.y++
			@setAnimation("move_#{direction}")
			@orientation = direction
			@move(pos.x, pos.y, =>
				@setAnimation("idle_#{direction}")
				callback()
			)

		enableSmoothMvmt: ->
			@elt.style.transitionProperty = 'top, left'
			@elt.style.transitionDuration = (1 / @speed) + 's'
			@elt.style.transitionTimingFunction = 'linear'

		disableSmoothMvmt: ->
			@elt.style.transition = 'none'
			@elt.style.transitionProperty = ''


	return Character
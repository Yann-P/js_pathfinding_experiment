define ['lib/jquery', 'data', 'types', 'entity'], ($, Data, Types, Entity) ->

	class Character extends Entity

		constructor: (id, kind) ->
			super(id, kind)
			@moveStack = []
			@orientation = Types.Directions.DOWN

		setMoveStack: (moveStack) ->
			@moveStack = moveStack
			@nextMove()

		nextMove: ->
			return unless @moveStack.length > 1
			source = @moveStack[0]
			dest = @moveStack[1]
			direction = null

			console.log source
			if source[0] != @x or source[1] != @y
				throw "Source isn't current character position"

			if Math.abs(source[0] - dest[0]) + Math.abs(source[1] - dest[1]) > 1
				throw "There must be exactly one coordinate change between source and dest"

			# Déplacement
			if source[0] - dest[0] == -1
				direction = Types.Directions.RIGHT # x+
			else if source[0] - dest[0] == 1
			    direction = Types.Directions.LEFT # x-
			else if source[1] - dest[1] == -1
				direction = Types.Directions.DOWN # y+	
			else if source[1] - dest[1] == 1
				direction = Types.Directions.UP # y-
			else throw "Impossible move"

			@moveTowards(direction, =>
				@nextMove()
			)
			@moveStack.splice(0, 1) # On enlève le 1er élément du moveStack

		moveTowards: (direction, callback) ->
			pos = { x: @x, y: @y }
			switch direction
				when Types.Directions.LEFT
					pos.x--
				when Types.Directions.RIGHT
					pos.x++
				when Types.Directions.UP
					pos.y--
				when Types.Directions.DOWN
					pos.y++
			@sprite.setAnimation("move_#{direction}")
			@orientation = direction
			@moveElt(pos.x, pos.y, =>
				@sprite.setAnimation("idle_#{direction}")
				callback()
			)


	return Character
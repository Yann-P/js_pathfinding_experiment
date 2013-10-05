define ['animation'], ->

	class Effect

		constructor: (@effectid, @x, @y, @duration, @size) ->
			@start()

		start: ->
			
define ['data'], (Data) ->

	class Animation
		constructor: (name, frames, interval, sprite) ->
			@name = name
			@sprite = sprite
			@ticks = 0
			@currentTimeout = null
			@frames = frames
			@interval = interval or 200

		start: (@nbLoops, @callback) ->
			@stop()
			@tick()

		tick: ->
			frameid = @frames[@ticks++ % @frames.length]
			@sprite.setFrame(frameid)
			if @frames.length == 1 # Si l'animation n'est composée que d'une frame, inutile de faire tourner l'animation
				return @stop()

			if @nbLoops? and @ticks == @nbLoops * @frames.length # Si un certain nombre de boucles était défini et qu'il est atteint
				if @callback 	# Si un callback était défini après ce nb de boucles, on l'exécute
					@callback()
				return @stop()

			@currentTimeout = window.setTimeout(=>
				@tick()
			, @interval)
			
		stop: ->
			@ticks = 0
			window.clearTimeout(@currentTimeout)

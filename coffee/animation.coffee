define ['data'], (Data) ->
	class Animation
		constructor: (name, frames, interval, sprite) ->
			@name
			@sprite = sprite
			@ticks = 0
			@currentTimeout = null
			@frames = frames
			@interval = interval or 100

		start: ->
			@stop()
			@tick()

		tick: ->
			frameid = @frames[@ticks++ % @frames.length]
			@sprite.setFrame(frameid)
			@currentTimeout = setTimeout(=>
				@tick()
			, @interval)
			
		stop: ->
			@ticks = 0
			clearTimeout(@currentTimeout)

	return Animation
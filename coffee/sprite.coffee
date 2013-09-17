define ['data'], (Data) ->
	class Sprite

		constructor: (name, entity) ->
			@name = name
			@entity = entity
			@currentAnimation = null
			@currentAnimationTicks = 0
			@currentAnimationTimeout = null

			data = Data.store.sprites[@name]
			@nbFramesWidth = data.nbFramesWidth
			@frameWidth = data.width
			@frameHeight = data.height
			@filepath = data.filepath
			@animations = data.animations

		setFrame: (id) ->
		    x = (id % @nbFramesWidth) * 32
		    y = Math.floor(id / @nbFramesWidth) * 32
		    @entity.setBackground(@filepath, x, y)

		setAnimation: (name) ->
			@stopAnimation()
			@currentAnimation = @animations[name]
			@tickAnimation()

		tickAnimation: ->
			frames = @currentAnimation.frames
			frameid = frames[@currentAnimationTicks % frames.length]
			@setFrame(frameid)
			@currentAnimationTicks++
			@currentAnimationTimeout = setTimeout(=>
				@tickAnimation()
			, @currentAnimation.interval or 100)
			
		stopAnimation: ->
			@currentAnimationTicks = 0
			clearTimeout(@currentAnimationTimeout)

	return Sprite

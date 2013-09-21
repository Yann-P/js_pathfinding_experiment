define ['data', 'animation'], (Data, Animation) ->
	class Sprite

		constructor: (name, entity) ->
			@name = name
			@entity = entity
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

		
		createAnimations: ->
			animations = {}
			for name, data of @animations
				animations[name] = new Animation(name, data.frames, data.interval, @)
			return animations

	return Sprite

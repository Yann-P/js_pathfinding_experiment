define ['data', 'animation'], (Data, Animation) ->
	class Sprite

		constructor: (name, entity) ->
			@name = name
			@entity = entity
			data = Data.store.sprites[@name] or throw "Sprite '#{name}' inexistant"
			@nbFramesWidth = data.nbFramesWidth
			@frameWidth = data.width
			@frameHeight = data.height
			@filepath = data.filepath
			@animations = data.animations

		setFrame: (id) ->
		    x = (id % @nbFramesWidth) * @frameWidth
		    y = Math.floor(id / @nbFramesWidth) * @frameHeight
		    @entity.setBackground(@filepath, x, y)

		createAnimations: ->
			animations = {}
			for name, data of @animations
				animations[name] = new Animation(name, data.frames, data.interval, @)
			return animations

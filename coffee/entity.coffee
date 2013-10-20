define ['jquery', 'data', 'sprite', 'animation', 'character'], ($, Data, Sprite, Animation, Character) ->

	class Entity

		constructor: (id, kind) ->
			@id = id
			@kind = kind
			@x = @y = 0
			@offsetX = @offsetY = 0
			@elt = null
			@sprite = null
			@currentAnimation = null
			@sprite = new Sprite(@kind, @)
			@animations = @sprite.createAnimations()
			@createElt()

		createElt: ->
			elt = document.createElement('div')
			$(elt)
				.addClass('entity')
				.appendTo('#game')
				.css({
					width: @sprite.frameWidth,
					height: @sprite.frameHeight
				})
			return @elt = elt

		setBackground: (imagepath, x, y) ->
			@elt.style.backgroundImage = "url('resources/img/sprites/#{imagepath}')"
			@elt.style.backgroundPosition = (-x) + 'px ' + (-y) + 'px'

		setPosition: (x, y) ->
			@x = x
			@y = y
			@elt.style.left = (x * 32) - @offsetX + 'px'
			@elt.style.top  = (y * 32) - @offsetY + 'px'

		setOffset: (left, top) -> # À exécuter avant setPosition()
			@offsetX = left
			@offsetY = top

		setAnimation: (animationid, nbLoops, callback) -> ## Revoir
			if @currentAnimation && @currentAnimation.name == animationid # Si la même animation n'est pas déjà en cours
				return
			animation = @animations[animationid] or throw "Cette entité n'a pas d'animation #{animationid}"
			if @currentAnimation
				@currentAnimation.stop()
			@currentAnimation = animation
			@currentAnimation.start(nbLoops, callback)

		clearAnimation: ->
			if @currentAnimation
				@currentAnimation.stop()

		remove: ->
			console.log "Remove entity"
			@clearAnimation()
			document.getElementById('game').removeChild(@elt)
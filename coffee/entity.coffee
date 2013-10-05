define ['lib/jquery', 'data', 'sprite', 'animation', 'character'], ($, Data, Sprite, Animation, Character) ->

	class Entity

		constructor: (id, kind) ->
			@id = id
			@kind = kind
			@x = 0
			@y = 0
			@elt = null
			@sprite = null
			@currentAnimation = null
			@sprite = new Sprite(@kind, @)
			@animations = @sprite.createAnimations()
			@createElt()
			@setAnimation('idle_down')

		createElt: ->
			elt = document.createElement('div')
			$(elt).addClass('entity').appendTo('#game')
			return @elt = elt

		setBackground: (imagepath, x, y) ->
			@elt.style.backgroundImage = "url('resources/img/#{imagepath}')"
			@elt.style.backgroundPosition = (-x) + 'px ' + (-y) + 'px'

		setPosition: (x, y) ->
			@x = x
			@y = y
			@elt.style.left = (x * 32) + 'px'
			@elt.style.top  = (y * 32) + 'px'

		setAnimation: (animationid) ->
			if @currentAnimation && @currentAnimation.name == animationid # Si la même animation n'est pas déjà en cours
				return
			animation = @animations[animationid] or throw "Cette entité n'a pas d'animation #{animationid}"
			if @currentAnimation
				@currentAnimation.stop()
			@currentAnimation = animation
			@currentAnimation.start()

		clearAnimation: ->
			if @currentAnimation
				@currentAnimation.stop()

		remove: ->
			console.log "Remove entity"
			@clearAnimation()
			@elt.remove()
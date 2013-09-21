define ['lib/jquery', 'data', 'sprite', 'animation'], ($, Data, Sprite, Animation) ->

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
			@elt = document.createElement('div')
			$(@elt).addClass('entity').appendTo('#game')

		setBackground: (imagepath, x, y) ->
			@elt.style.backgroundImage = "url('resources/img/#{imagepath}')"
			@elt.style.backgroundPosition = (-x) + 'px ' + (-y) + 'px'

		setPosition: (x, y) ->
			@x = x
			@y = y
			@elt.style.left = (x * 32) + 'px'
			@elt.style.top  = (y * 32) + 'px'

		setAnimation: (animationid) ->
			animation = @animations[animationid]
			if(@currentAnimation instanceof Animation)
				@currentAnimation.stop()
			@currentAnimation = animation
			@currentAnimation.start()

		remove: -> # À vérifier/compléter
			@elt.remove()
			delete @






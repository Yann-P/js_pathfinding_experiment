
define ['lib/jquery', 'data', 'sprite'], ($, Data, Sprite) ->

	class Entity

		constructor: (id, kind) ->
			@id = id
			@kind = kind
			@x = 0
			@y = 0
			@elt = null
			@sprite = null

			@sprite = new Sprite(@kind, @)
			@createElt()

		createElt: ->
			@elt = document.createElement('div')
			$(@elt).addClass('entity').appendTo('#game')

		setBackground: (imagepath, x, y) ->
			@elt.style.backgroundImage = "url('resources/img/#{imagepath}')"
			@elt.style.backgroundPositionX = -x + 'px'
			@elt.style.backgroundPositionY = -y + 'px'

		setPosition: (x, y, render) ->
			@x = x
			@y = y
			if render
				@elt.style.left = @x * 32 + 'px'
				@elt.style.top = @y * 32 + 'px'

		moveElt: (x, y, callback) ->
			console.log('move')
			$elt = $(@elt)
			$elt.animate({
				left: x * 32,
				top: y * 32
			}, 1000 / @speed, 'linear', =>
				@setPosition(x, y, true)
				callback()
			)





	return Entity





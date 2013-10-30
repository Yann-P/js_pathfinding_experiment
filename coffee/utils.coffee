define [], ->

	Utils = {

		getRandomElement: (obj) ->
			return obj[Math.floor(Math.random() * obj.length)]

		setTransitionDuration: (elt, duration) ->
			elt.style.transitionDuration = duration + 's'
			elt.style.WebkitTransitionDuration = duration + 's'
			elt.style.MozTransitionDuration = duration + 's'
			elt.style.OTransitionDuration = duration + 's'

		createDebugEntity: (x, y, color, removeAfter, className) ->
			$debug = $('<div>').addClass('debug entity').css({
				height: 32, width: 32,
				top: y * 32, left: x * 32,
				background: color
				opacity: 0.4
			}).appendTo('#game')
			if className
				$debug.attr('data-classname', className)
			if removeAfter != -1
				setTimeout( =>
					$debug.remove()
				, removeAfter)

		removeDebugEntities: (className) ->
			$('.entity.debug[data-classname="' + className + '"]').remove()


	}

	return Utils
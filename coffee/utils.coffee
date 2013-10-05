define [], ->

	Utils = {

		getRandomElement: (obj) ->
			return obj[Math.floor(Math.random() * obj.length)]

		setTransitionDuration: (elt, duration) ->
			elt.style.transitionDuration = duration + 's'
			elt.style.WebkitTransitionDuration = duration + 's'
			elt.style.MozTransitionDuration = duration + 's'
			elt.style.OTransitionDuration = duration + 's'
	}
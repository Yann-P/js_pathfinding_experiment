# Évite les problèmes de cache
requirejs.config({
	urlArgs: 'v=' + Date.now()
})

window.app = null

define ['lib/jquery', 'app', 'game'], ($, App, Game) ->
		
	$ ->
		window.app = new App()
		
		app.center()
		app.switchView('loading')

		app.load ->
			app.initLevelSelector()
			app.switchView('menu')

		$(window).resize ->
			app.center()

		$('*[data-goto]').each ->
			$elt = $(this)
			$elt.bind 'click', ->
				view = $elt.attr('data-goto')
				app.switchView(view)

		$('#level-selector').on 'click', '.level', ->
			level = $(this).attr('data-level')
			console.log "Chargement du niveau #{level}"

			app.startGame(level)
			
			
		
		


		
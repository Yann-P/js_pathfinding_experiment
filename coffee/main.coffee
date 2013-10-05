# Évite les problèmes de cache
requirejs.config({
	urlArgs: 'v=' + Date.now()
})

window.app = null

define ['lib/jquery', 'app'], ($, App) ->
		
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
			levelid = $(this).attr('data-levelid')
			console.log "Chargement du niveau #{levelid}"

			app.startLevel(levelid)
			
			
		
		


		
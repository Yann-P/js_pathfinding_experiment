# Évite les problèmes de cache
require.config({
	urlArgs: "v=" +  Date.now()
	paths: {
		## Ne marche pas en local :(
        'jquery': 'http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min',
        'astar': 'http://yann-p.fr/zombies/js/lib/astar' 
    }
    shim: {
        'jquery': { exports: '$' },
        'astar': { exports: 'AStar' }
    }
})

window.app = null

define ['jquery', 'app'], ($, App) ->

	$ ->

		app = new App()
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
			
			
		
		


		
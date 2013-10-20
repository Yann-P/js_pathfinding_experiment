define ['jquery', 'data', 'level'], ($, Data, Level) ->
	# Classe à instancier une fois qui fait tourner tout le bazar.
	# S'occupe des menus et de lancer le jeu
	class App

		constructor: ->
			@currentLevel = null

		# Charger toutes les données JSON, et précharger les images listées dans setup.json
		load: (callback) ->
			Data.load(callback)

		# Créer le sélecteur de niveau à partir des données de levelselector.json
		initLevelSelector: ->
			index = 1
			for levelid, position of Data.store.levelselector.levels
				$('<div></div>', {
					'class': 'level', 
					'data-levelid': levelid
				})
				.text(index)
				.css({
					left: position[0] - 25
					top: position[1] - 25
				})
				.appendTo('#level-selector')
				index++

		# Lancer un niveau.
		startLevel: (levelid) ->
			@switchView('game')
			level = new Level(levelid, @)
			@currentLevel = level

		# Centrer la zone de jeu.
		center: ->
			top = window.innerHeight / 2 - 576 / 2
			left = window.innerWidth / 2 - 928 / 2
			$('.view').css({
				top:  if top < 0  then 0 else top
				left: if left < 0 then 0 else left
			})

		# Changer de vue (menu, game, level-selector...) en cachant les autres
		switchView: (view) ->
			$(".view").hide()
			$(".view[data-view='#{view}']").show()
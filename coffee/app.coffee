define ['lib/jquery', 'data', 'game'], ($, Data, Game) ->

	class App

		constructor: ->
			@currentGame = null

		load: (callback) ->
			Data.load(callback)

		initLevelSelector: ->
			index = 1
			for level, position of Data.store.levelselector.levels
				$('<div></div>', {
					'class': 'level', 
					'data-level': level
				})
				.text(index)
				.css({
					left: position[0] - 25
					top: position[1] - 25
				})
				.appendTo('#level-selector')
				index++
			

		startGame: (level) ->
			game = new Game(level, @)
			@currentGame = game
			@switchView('game')

		center: ->
			top = window.innerHeight / 2 - 576 / 2
			left = window.innerWidth / 2 - 928 / 2
			$('.view').css({
				top: if top < 0 then 0 else top
				left: if left < 0 then 0 else left
			})

		switchView: (view) ->
			$(".view").hide()
			$(".view[data-view='#{view}']").show()

	return App
define ['lib/jquery', 'data', 'level'], ($, Data, Level) ->

	class App

		constructor: ->
			@currentLevel = null

		load: (callback) ->
			Data.load(callback)

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

		startLevel: (levelid) ->
			@switchView('game')
			level = new Level(levelid, @)
			@currentLevel = level

		center: ->
			top = window.innerHeight / 2 - 576 / 2
			left = window.innerWidth / 2 - 928 / 2
			$('.view').css({
				top:  if top < 0  then 0 else top
				left: if left < 0 then 0 else left
			})

		switchView: (view) ->
			$(".view").hide()
			$(".view[data-view='#{view}']").show()
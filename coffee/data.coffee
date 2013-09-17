define [], ->

	window.Data = {

		store: {}

		files: [
			'sprites'
			'levels'
			'levelselector'
			'zombies'
		]

		preload: [
			# À faire
		]

		load: (callback) ->
			@getFiles(=>
				@preloadImages(callback)
			)
			

		loadImageInCache: (url, callback) ->
			image = new Image()
			image.onload = callback
			image.src = url

		preloadImages: (callback) -> # À faire
			callback()

		getFiles: (callback, index = 0) -> # Récursive
			file = @files[index]
			url = "resources/#{file}.json"

			$.ajax({
				dataType: "json"
				url: url
				cache: false
				success: (data) =>
					@store[file] = data
					if index is @files.length - 1 # Dernier truc à charger
						callback()
					else
						@getFiles(callback, index + 1)
				error: =>
					console.log("Error loading JSON")
			})
	}

	return Data
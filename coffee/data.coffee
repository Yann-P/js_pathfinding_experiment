define [], ->

	## Revoir sructure
	window.Data = {

		store: {}

		load: (callback) ->
			$.ajax({
				dataType: "json"
				url: "resources/setup.json"
				cache: false
				success: (data) =>
					@getFiles(data.load.json, =>
						@preloadImages(callback)
					)
				error: =>
					throw "Cannot load setup.json."
			})

		loadImageInCache: (url, callback) ->
			image = new Image()
			image.onload = callback
			image.src = url

		preloadImages: (callback) -> ## À faire
			callback()

		getFiles: (files, callback, index = 0) -> # Récursive
			file = files[index]
			url = "resources/#{file}.json"

			$.ajax({
				dataType: "json"
				url: url
				cache: false
				success: (data) =>
					@store[file] = data
					if index is files.length - 1 # Dernier truc à charger
						callback()
					else
						@getFiles(files, callback, index + 1)
				error: =>
					throw "Error loading JSON"
			})
	}

	return Data
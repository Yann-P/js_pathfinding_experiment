CONFIG = {
	RESOURCES_PATH: "../resources/img/sprites/"
}

// Sprite
function Sprite(name) {
	this.name = name
	this.animations = {}
}
Sprite.prototype = {
	setImage: function(fileName, callback) {
		var self = this,
			path = CONFIG.RESOURCES_PATH + fileName,
			image = new Image();
		image.onerror = function() { 
			return callback(false)
		}
		image.onload  = function() { 
			self.imagePath = path
			self.width = image.width
			self.height = image.height
			callback(true)
		}
		image.src = path;
	}
};


// Animation
function Animation(sprite) {
	this.sprite = sprite
	this.frames = []
}
Animation.prototype = {
	start: function() {

	},
	tick: function() {

	},
	stop: function() {

	}
};


// Spritesheet
function Spritesheet() {
	this.sprites = {}
}
Spritesheet.prototype = {
	addSprite: function(sprite) {
		this.sprites[sprite.name] = sprite 
	},
	removeSprite: function(spriteName) {
		delete this.sprites[spriteName]
	}
}

// UI
var UI = {
	switchView: function(view) {
		$('.view').hide()
		if(view)
			$('.view[data-view="' + view + '"]').show()
	},
	addSprite: function(sprite) {
		var $sprite = $('<li></li>');
		$('<a></a>', { 'href': '#', 'data-sprite': sprite.name })
			.text(sprite.name)
			.appendTo($sprite);
		$('#sprite-list').append($sprite);
		spritesheet.addSprite(sprite);
	},
	creation: {
		newSprite: function() {
			UI.switchView('sprite-creation')
		},
		getField: function(name) {
			return $('#create-sprite input[name="' + name + '"]')
		},
		setLoading: function(isLoading) {
			$('body').css('opacity', isLoading ? 0.8 : 1);
		},
		createSprite: function() {
			var name 			= UI.creation.getField('sprite-name').val(),
				url 			= UI.creation.getField('sprite-image').val(),
				frameHeight 	= UI.creation.getField('frame-width').val(),
				frameWidth 		= UI.creation.getField('frame-height').val(),
				$spriteWidth 	= UI.creation.getField('sprite-width'),
				$spriteHeight 	= UI.creation.getField('sprite-height'),
				$framesByLine 	= UI.creation.getField('frames-by-line'),
				sprite = new Sprite(name);

			UI.creation.setLoading(true);
			sprite.setImage(url, function(result) {
				UI.creation.setLoading(false);
				if(result) { // Image OK
					$('#preview').css({
						height: sprite.height,
						width: sprite.width,
						background: "url(" + sprite.imagePath + ")"
					});
					$spriteWidth.val(sprite.width);
					$spriteHeight.val(sprite.height);
					if(frameWidth && frameHeight) {
						if( (sprite.width / frameWidth)%1 == 0  && (sprite.height / frameHeight) % 1 == 0 ) {
							if(confirm(sprite.width / frameWidth + "frames en largeur au max. \n")
								&& confirm(sprite.height / frameHeight + "frames en hauteur au max. OK ?")) {
								UI.addSprite(sprite);
							}
						} else return alert("Merci de vérifier la taille d'une frame. La taille du sprite n'est pas divisible par la taille de la frame.");
					}
				} else return alert("Aucune image n'a été trouvée");
				
			});
		}
	}
}

//
window.spritesheet = new Spritesheet();

$(document).ready(function() {
	$('#resources-path').text(CONFIG.RESOURCES_PATH)
	UI.switchView(null);
	$('#new-sprite').click(UI.creation.newSprite)
	$('#create-sprite').submit(function(e) {
		e.preventDefault()
		UI.creation.createSprite()
	})
});
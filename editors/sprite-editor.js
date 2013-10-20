var sprites = {},
	currentSpriteid = null;

var getSpriteImageUrl = function(spriteid) {
	return "../resources/img/sprites/" + spriteid + ".png";
};

var newSprite = function() {
	var name = prompt('Nom du sprite ?', 'zombie_ogre'),
		$sprite = $('<li></li>');
	if(!name || sprites[name])
		return;
	$('<a></a>', { 'href': '#', 'data-sprite': name })
		.text(name)
		.appendTo($sprite);
	$('#sprite-list').append($sprite);

	sprites[name] = {
		width: null,
		height: null,
		frame: {
			width: null,
			height: null
		},
		animations: {}
	};

	var image = new Image();

	image.onerror = function() {
		alert("Le sprite '" + name + "'' n'a pas d'image PNG à son nom dans resources/sprites/. Merci de créer l'image avant.");
		removeSprite(name);
	};
	image.onload = function() {
		sprites[name].width = image.width;
		sprites[name].height = image.height;
		selectSprite(name);
	};
	image.src = getSpriteImageUrl(name);
};

var selectSprite = function(spriteid) {
	currentSpriteid = spriteid;
	if(!sprites[spriteid])
		return alert("Sprite inexistant, sélection impossible !");
	$('#current-sprite-name').text(spriteid);
	$('#sprite-modification').show();
	$('#sprite-properties input[name="sprite-width"]').val(sprites[spriteid].width);
	$('#sprite-properties input[name="sprite-height"]').val(sprites[spriteid].height);
	$('#sprite-image').css({
		background: "url(" + getSpriteImageUrl(spriteid) + ")",
		height: sprites[spriteid].height,
		width: sprites[spriteid].width
	})

};

var removeSprite = function(spriteid) {
	$('#sprite-list').find('li a[data-sprite="' + spriteid + '"]').parent().remove();
	delete sprites[spriteid];
	$('#sprite-modification').hide();
};

var exportJSON = function() {
	$('#exported-json').text(JSON.stringify(sprites, null, 2));
};

$(function() {
	$('#sprite-modification').hide();
	$('#import').click(function() {
		if(confirm("Vous perdrez la feuille de sprites que vous êtes en train d'éditer")) {
			
		}
	});
	$('#sprite-list').on('click', 'a[data-sprite]', function() {
		var spriteid = $(this).attr('data-sprite');
		selectSprite(spriteid);
	});
	$('#remove-current-sprite').click(function() {
		if(confirm('Le sprite sera supprimé'))
			removeSprite(currentSpriteid);
	});
	$('#new-sprite').click(function() {
		newSprite();
	});
	$('#export').click(function() {
		exportJSON();
	});
});
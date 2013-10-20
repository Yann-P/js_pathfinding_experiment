define ['entity', 'animation'], (Entity, Animation) ->

	class Effect extends Entity

		constructor: (id, effectid, permanent) ->
			@effectid = effectid
			@permanent = permanent # Si permanent = false, l'animation sera infinie. Sinon, l'entité est détruite dès qu'elle a été jouée 1x
			super(id, 'effect_' + effectid) # kind (2e arg) est important, il détermine le sprite

		playAt: (x, y, callback) ->
			@setOffset(@sprite.frameWidth / 2 - 16, @sprite.frameHeight / 2 - 16)
			@setPosition(x, y)

			@setAnimation('default', 1, callback)

		remove: ->
			console.log "remove effect"
			Entity.prototype.remove.call(@)
			

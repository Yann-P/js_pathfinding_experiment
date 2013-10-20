define ['entity'], (Entity) ->

	class Tower extends Entity

		constructor: (id, kind) ->
			@upgradeLevel = 0
			data = Data.store.towers[kind] or throw "Tower '#{kind}' inexistante"

			{ @health, @width, @height, @resistance, @villagers, @door } = data
			super(id, kind)
			@setUpgradeLevel(0)

		## Tower aura son propre système de barre de vie etc. N'hérite pas de Character. Ne pas descendre le système de vie à Entity.

		setUpgradeLevel: (level) ->
			@upgradeLevel = level
			@setAnimation('upgrade_' + level)

		onRemove: (callback) ->
			@removeCallback = callback

		remove: ->
			console.log "remove tower"
			@removeCallback()
			Entity.prototype.remove.call(@)
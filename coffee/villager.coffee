define ['character'], (Character) ->

	class Villager extends Character
		
		constructor: (id, kind) ->
			data = Data.store.villagers[kind] or throw "Villager '#{kind}' inexistant"
			{ @type, @health, @strength, @resistance, @speed } = data
			@maxHealth = @health
			super(id, kind)


define ['lib/jquery', 'data', 'character'], ($, Data, Character) ->

	class Zombie extends Character
		
		constructor: (id, kind) ->
			data = Data.store.zombies[kind] or throw "Zombie '#{kind}' inexistant"
			{ @type, @health, @strength, @resistance, @speed } = data
			@maxHealth = @health
			super(id, kind)
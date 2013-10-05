define ['lib/jquery', 'data', 'character'], ($, Data, Character) ->

	class Zombie extends Character
		
		constructor: (id, kind) ->
			data = Data.store.zombies[kind]
			{ @health, @strength, @speed } = data
			@maxHealth = @health
			super(id, kind)
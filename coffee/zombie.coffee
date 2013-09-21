define ['lib/jquery', 'data', 'character'], ($, Data, Character) ->

	class Zombie extends Character
		
		constructor: (id, kind) ->
			data = Data.store.zombies[kind]
			@health = data.health
			@strength = data.strength
			@speed = data.speed
			super(id, kind)
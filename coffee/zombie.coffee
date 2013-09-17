define ['lib/jquery', 'data', 'character'], ($, Data, Character) ->

	class Zombie extends Character
		
		constructor: (id, kind) ->
			super(id, kind)

			data = Data.store.zombies[@kind]
			@health = data.heath
			@strength = data.strength
			@speed = data.speed


	return Zombie
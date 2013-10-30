// Generated by CoffeeScript 1.3.3
(function() {

  define([], function() {
    var Wave;
    return Wave = (function() {

      function Wave(id, zombiesList, interval, next, level) {
        this.id = id;
        this.zombiesList = zombiesList;
        this.interval = interval;
        this.next = next || 0;
        this.level = level;
        this.nextZombieTimeout = null;
        this.callback = null;
      }

      Wave.prototype.start = function(callback) {
        var i, nb, zombieType, _i, _ref;
        this.callback = callback;
        this.stack = [];
        _ref = this.zombiesList;
        for (zombieType in _ref) {
          nb = _ref[zombieType];
          for (i = _i = 0; 0 <= nb ? _i < nb : _i > nb; i = 0 <= nb ? ++_i : --_i) {
            this.stack.push(zombieType);
          }
        }
        console.log("Vague #" + this.id + " commencée (" + this.stack.length + " zombies)");
        return this.tick();
      };

      Wave.prototype.tick = function() {
        var zombie,
          _this = this;
        if (this.stack.length === 0) {
          console.log("Vague #" + this.id + " terminée. " + this.next + "s avant prochaine");
          return setTimeout(function() {
            console.log("Temps écoulé");
            return _this.callback();
          }, this.next * 1000);
        }
        zombie = this.level.addZombie(14, 17, this.stack[0]);
        zombie.moveTo(Math.floor(Math.random() * 29), Math.floor(Math.random() * 18));
        this.stack.splice(0, 1);
        return this.nextZombieTimeout = window.setTimeout(function() {
          return _this.tick();
        }, this.interval * 1000);
      };

      Wave.prototype.stop = function() {
        return window.clearTimeout(this.nextZombieTimeout);
      };

      return Wave;

    })();
  });

}).call(this);

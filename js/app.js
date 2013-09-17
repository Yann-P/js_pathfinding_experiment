// Generated by CoffeeScript 1.3.3
(function() {

  define(['lib/jquery', 'data', 'game'], function($, Data, Game) {
    var App;
    App = (function() {

      function App() {
        this.currentGame = null;
      }

      App.prototype.load = function(callback) {
        return Data.load(callback);
      };

      App.prototype.initLevelSelector = function() {
        var index, level, position, _ref, _results;
        index = 1;
        _ref = Data.store.levelselector.levels;
        _results = [];
        for (level in _ref) {
          position = _ref[level];
          $('<div></div>', {
            'class': 'level',
            'data-level': level
          }).text(index).css({
            left: position[0] - 25,
            top: position[1] - 25
          }).appendTo('#level-selector');
          _results.push(index++);
        }
        return _results;
      };

      App.prototype.startGame = function(level) {
        var game;
        game = new Game(level, this);
        this.currentGame = game;
        return this.switchView('game');
      };

      App.prototype.center = function() {
        var left, top;
        top = window.innerHeight / 2 - 576 / 2;
        left = window.innerWidth / 2 - 928 / 2;
        return $('.view').css({
          top: top < 0 ? 0 : top,
          left: left < 0 ? 0 : left
        });
      };

      App.prototype.switchView = function(view) {
        $(".view").hide();
        return $(".view[data-view='" + view + "']").show();
      };

      return App;

    })();
    return App;
  });

}).call(this);
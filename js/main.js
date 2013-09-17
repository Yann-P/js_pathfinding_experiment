// Generated by CoffeeScript 1.3.3
(function() {

  requirejs.config({
    urlArgs: 'v=' + Date.now()
  });

  window.app = null;

  define(['lib/jquery', 'app', 'game'], function($, App, Game) {
    return $(function() {
      window.app = new App();
      app.center();
      app.switchView('loading');
      app.load(function() {
        app.initLevelSelector();
        return app.switchView('menu');
      });
      $(window).resize(function() {
        return app.center();
      });
      $('*[data-goto]').each(function() {
        var $elt;
        $elt = $(this);
        return $elt.bind('click', function() {
          var view;
          view = $elt.attr('data-goto');
          return app.switchView(view);
        });
      });
      return $('#level-selector').on('click', '.level', function() {
        var level;
        level = $(this).attr('data-level');
        console.log("Chargement du niveau " + level);
        return app.startGame(level);
      });
    });
  });

}).call(this);

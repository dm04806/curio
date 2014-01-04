var path_ = require('path');

var koa = require('koa');
var spa = require('koa-spa');
var consts = require('./app/consts');

var ONE_DAY = 24 * 60 * 60;
var lc_cookie = consts.LOCALE_COOKIE;
/**
 * Find out what languages user can use
 */
function detectLanguage(availables) {
  return function *(next) {
    if (!this.cookies.get(lc_cookie)) {
      var accept = this.acceptsLanguages(availables);
      if (accept) {
        this.cookies.set(lc_cookie, accept, {
          httpOnly: false,
          signed: false,
          expires: new Date(+new Date() + 3000 * ONE_DAY)
        });
      }
    }
    yield next;
  }
}


exports.startServer = function(port, path, callback) {
  var server;
  var app = koa(), routes = {};

  // collect all available routes
  require('./app/routes')(spa.routeCollector(routes));

  app.use(spa(path_.join(__dirname, path), {
     index: 'index.html',
     routeBase: '/',
     routes: routes
  }));
  app.use(detectLanguage(Object.keys(consts.LOCALES)));
  // add your custom 404 page
  app.use(function* () {
    if (this.status == 404) {
      this.body = '没有这个玩意儿';
    }
  });

  server = app.listen(port);

  callback();

  return server;
};

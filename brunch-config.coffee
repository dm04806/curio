consts = require './app/consts'

#lc_cookie = consts.LOCALE_COOKIE

# Find out what languages user can use
#detectLanguage = (availables) ->
  #return `function *() {
    #if (!this.cookie.get(lc_cookie)) {
      #var accept = this.acceptLanguages(availables);
      #if (accept) {
        #this.cookie.set(lc_cookie, accept);
      #}
    #}
  #}`


exports.config =
  # See http://brunch.io/#documentation for docs.
  notifications: false
  server:
    path: 'server.js'
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app.*(?!admin)/
        'js/vendor.js': /^(?!app)/
    stylesheets:
      joinTo:
        'css/app.css': /^app/
        'css/bootstrap.css': /bootstrap/
    templates:
      joinTo: 'js/app.js'
  plugins:
    #koaServer:
      #onRoute: detectLanguage(Object.keys(consts.LOCALES))
    autoReload:
      enabled:
        css: on
        js: on
        assets: off
      port: [1234, 2345, 3456]
      delay: 200 if require('os').platform() is 'win32'
    stylus:
      plugins: ['nib']
      imports: ['nib', 'app/styles/_variables']
    yamlI18n:
      locale:
        default: 'en'
        all: Object.keys(consts.LOCALES)

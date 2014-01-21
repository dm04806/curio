consts = require './app/consts'

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
        default: 'zh-cn'
        all: Object.keys(consts.LOCALES)

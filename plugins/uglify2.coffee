uglify = require 'uglify-js'
fs = require 'fs'

module.exports = (env, callback) ->

  class Uglify2Plugin extends env.ContentPluginn

    constructor: (@filepath) ->
    
    getFilename: ->
      @filepath.relative + '.js'
    
    getView: -> (env, locals, contents, templates, callback) ->
      callback(null, new Buffer("DummyText"))
      
  Uglify2Plugin.fromFile = (filepath, callback) ->
    callback null, new Uglify2Plugin filepath
  
  env.registerContentPlugin 'scripts', '**/*.ugljs', Uglify2Plugin
  callback() # tell the plugin manager we are done
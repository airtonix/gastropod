#
# Framework
debug = require('debug')('gastropod/plugins')

#
# Exportable
plugins = require('gulp-load-plugins')()
plugins.through = require 'through2'
plugins.throughPipes = require 'through-pipes'
plugins.browserify = require 'browserify'
plugins.source = require 'vinyl-source-stream'
plugins.buffer = require 'vinyl-buffer'
plugins.globby = require 'globby'
plugins.transform = require 'vinyl-transform'
plugins.runsequence = require 'run-sequence'
plugins.browsersync = require('browser-sync').create()
plugins.nghtml2js = require 'browserify-ng-html2js'
plugins.del = require 'del'
plugins.vinylPaths = require 'vinyl-paths'
plugins.end = require 'stream-end'
plugins.merge = require 'merge-stream'

#
# Project Plugins
plugins.swig = require './swig'
plugins.fingerprint = require './fingerprinter'

module.exports = plugins
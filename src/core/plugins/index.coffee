
$ = require('gulp-load-plugins')()

$.through = require 'through2'
$.throughPipes = require 'through-pipes'
$.browserify = require 'browserify'
$.source = require 'vinyl-source-stream'
$.buffer = require 'vinyl-buffer'
$.globby = require 'globby'
$.transform = require 'vinyl-transform'
$.runsequence = require 'run-sequence'
$.browsersync = require('browser-sync').create()
$.nghtml2js = require 'browserify-ng-html2js'
$.del = require 'del'
$.vinylPaths = require 'vinyl-paths'

#
# Custom Plugins
$.fingerprinter = require('./fingerprinter')($)

module.exports = $
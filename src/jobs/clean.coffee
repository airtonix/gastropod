#
# Framework
debug = require('debug')('gastropod/jobs/clean')
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'

#
# Exportable
gulp.task 'clean', (done)->
	Plugins.runsequence 'clean:pages', 'clean:scripts', 'clean:styles', 'clean:copies', done

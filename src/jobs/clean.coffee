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
run = Plugins.runsequence

gulp.task 'clean', (done)->
	run([
		'clean:scripts'
		'clean:styles'
		'clean:images'
		'clean:fonts'
		'clean:pages'
	], done)

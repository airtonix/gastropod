#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/jobs/watch')
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'


gulp.task 'watch', (done)->
	debug 'Starting'
	done() unless Config?
	done() unless Config.watch
	source = path.join(Config.source.root,
					   Config.filters.all)

	debug('watching', source)
	gulp.watch source, ['compile'], (event)->
		debug 'Event', event.type

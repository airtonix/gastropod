#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/jobs/watch')
gulp = require 'gulp'
requireUncached = require 'require-uncached'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'


gulp.task 'reload-config', (done)->
	debug 'Reloading Config'
	{Config} = requireUncached('../config')


gulp.task 'watch', (done)->
	debug 'Starting'
	done() unless Config?
	done() unless Config.watch

	environments = path.join(process.cwd(), 'config', Config.filters.all)
	project = path.join(Config.source.root, Config.filters.all)

	debug('watching', [
		project,
		environments
	])

	gulp.watch project, ['compile'], (event)->
		debug 'Event', event.type

	gulp.watch environments, ['reload-config', 'compile'], (event)->
		debug 'Event', event.type

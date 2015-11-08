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
	done() unless Config? or Config.watch?

	debug 'creating watch paths'
	environments = path.join(process.cwd(), 'config', Config.filters.all)
	project = path.join(Config.source.root, Config.filters.all)
	scripts = path.join(Config.source.root,
						Config.source.scripts,
						Config.filters.all)
	styles = path.join(Config.source.root,
						Config.source.styles,
						Config.filters.all)

	debug 'creating pattern watch paths', Config.source.patterns
	patterns = []
	for patternRoot in Config.source.patterns
		debug 'creating pattern watch path:', patternRoot
		patterns.push path.join(patternRoot,
								Config.filters.all)

	debug 'creating copy task watch paths'
	copyTasks = []
	for task in Config.plugins.copy
		debug 'creating watch path:', task.src
		copyTasks.push path.join(Config.source.root, task.src)

	debug('watching', [
		scripts,
		styles,
		patterns,
		copyTasks,
		environments
	])

	gulp.watch scripts, (event)->
		debug 'File ' + event.path + ' was ' + event.type + ', running tasks...'
		if Config.fingerprint
			Plugins.runsequence 'scripts', 'manifest:scripts', 'pages'
		else
			Plugins.runsequence 'scripts'

	gulp.watch styles, (event)->
		debug 'File ' + event.path + ' was ' + event.type + ', running tasks...'
		if Config.fingerprint
			Plugins.runsequence 'styles', 'manifest:styles', 'pages'
		else
			Plugins.runsequence 'styles'

	gulp.watch copyTasks, (event)->
		debug 'File ' + event.path + ' was ' + event.type + ', running tasks...'
		if Config.fingerprint
			Plugins.runsequence 'copy', 'manifest:copy', 'pages'
		else
			Plugins.runsequence 'copy'

	gulp.watch patterns, (event)->
		debug 'File ' + event.path + ' was ' + event.type + ', running tasks...'
		Plugins.runsequence 'pages'


	gulp.watch environments, (event)->
		debug 'File ' + event.path + ' was ' + event.type + ', running tasks...'
		Plugins.runsequence 'reload-config', 'compile'

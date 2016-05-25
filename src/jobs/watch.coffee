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
Config = require('../config')
Plugins = require '../plugins'
{Logger} = require '../core/logging'
logger = new Logger 'Server'

paths =
	patterns: (path.join(pattern, Config.Store.filters.all) for pattern in Config.Store.source.patterns)
	environments: path.join(process.cwd(), 'config', Config.Store.filters.all)
	data: path.join(Config.Store.source.root, Config.Store.source.data, Config.Store.filters.all)
	project: path.join(Config.Store.source.root, Config.Store.filters.all)
	scripts: path.join(Config.Store.source.root, Config.Store.source.scripts, Config.Store.filters.all)
	styles: path.join(Config.Store.source.root, Config.Store.source.styles, Config.Store.filters.all)
	copy: (path.join(Config.Store.source.root, task.src) for task in Config.Store.plugins.copy)

debug 'watch paths created'

gulp.task 'reload-config', (done)->
	debug 'Reloading Config'
	Config = requireUncached('../config')
	done()

gulp.task 'watch', [
		'watch:scripts'
		'watch:styles'
		'watch:copy'
		'watch:patterns'
		'watch:data'
		'watch:environments'
	]

gulp.task 'watch:scripts', (done)->
	logger.msg 'Scripts: Starting'
	gulp.watch paths.scripts, (event)->
		logger.msg "Scripts: File #{event.path} was #{event.type}"
		if Config.Store.fingerprint
			Plugins.runsequence 'clean:scripts', 'scripts', 'manifest:scripts', 'pages', 'documentation'
		else
			Plugins.runsequence 'scripts'
	logger.msg "watching scripts: #{paths.scripts}"

gulp.task 'watch:styles', (done)->
	logger.msg 'Styles: Starting'
	gulp.watch paths.styles, (event)->
		logger.msg "Styles: File #{event.path} was #{event.type}"
		if Config.Store.fingerprint
			Plugins.runsequence 'clean:styles', 'styles', 'manifest:styles', 'pages', 'documentation'
		else
			Plugins.runsequence 'styles'
	logger.msg "watching styles: #{paths.styles}"

gulp.task 'watch:data', (done)->
	logger.msg 'Data: Starting'
	gulp.watch paths.data, (event)->
		logger.msg "Data: File #{event.path} was #{event.type}"
		Plugins.runsequence 'pages', 'documentation'
	logger.msg "watching data: #{paths.data}"

gulp.task 'watch:copy', (done)->
	logger.msg 'Copy: Starting'
	gulp.watch paths.copy, (event)->
		logger.msg "CopyTasks: File #{event.path} was #{event.type}"
		if Config.Store.fingerprint
			Plugins.runsequence 'clean:copies', 'copy', 'manifest:copy', 'pages', 'documentation'
		else
			Plugins.runsequence 'copy'
	logger.msg "watching copy: #{paths.copy}"

gulp.task 'watch:patterns', (done)->
	logger.msg 'Patterns: Starting'
	gulp.watch paths.patterns, (event)->
		logger.msg "Patterns: File #{event.path} was #{event.type}"
		Plugins.runsequence 'clean:pages', 'pages', 'documentation'
	logger.msg "watching patterns: #{paths.patterns}"

gulp.task 'watch:environments', (done)->
	logger.msg 'Environment: Starting'
	gulp.watch paths.environments, (event)->
		logger.msg "Environments: File #{event.path} was #{event.type}"
		Plugins.runsequence 'reload-config', 'compile'
	logger.msg "watching environments: #{paths.environments}"


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
{Logger} = require '../core/logging'
logger = new Logger 'Server'

paths =
	patterns: (path.join(pattern, Config.filters.all) for pattern in Config.source.patterns)
	environments: path.join(process.cwd(), 'config', Config.filters.all)
	data: path.join(Config.source.root, Config.source.data, Config.filters.all)
	project: path.join(Config.source.root, Config.filters.all)
	scripts: path.join(Config.source.root, Config.source.scripts, Config.filters.all)
	styles: path.join(Config.source.root, Config.source.styles, Config.filters.all)
	copy: (path.join(Config.source.root, task.src) for task in Config.plugins.copy)

debug 'watch paths created'

gulp.task 'reload-config', (done)->
	debug 'Reloading Config'
	{Config} = requireUncached('../config')

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
		if Config.fingerprint
			Plugins.runsequence 'clean:scripts', 'scripts', 'manifest:scripts', 'pages', 'documentation'
		else
			Plugins.runsequence 'scripts'
	logger.msg "watching scripts: #{paths.scripts}"

gulp.task 'watch:styles', (done)->
	logger.msg 'Styles: Starting'
	gulp.watch paths.styles, (event)->
		logger.msg "Styles: File #{event.path} was #{event.type}"
		if Config.fingerprint
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
		if Config.fingerprint
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


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

gulp.task 'watch', (done)->
	Plugins.runsequence [
		'watch:scripts'
		'watch:styles'
		'watch:copy'
		'watch:patterns'
		'watch:data'
		'watch:environments'
	]

gulp.task 'watch:scripts', (done)->
	debug 'Starting'
	gulp.watch paths.scripts, (event)->
		debug "Scripts: File #{event.path} was #{event.type}"
		if Config.fingerprint
			Plugins.runsequence 'scripts', 'manifest:scripts', 'pages'
		else
			Plugins.runsequence 'scripts'
	debug "watching scripts: #{paths.scripts}"

gulp.task 'watch:styles', (done)->
	debug 'Starting'
	gulp.watch paths.styles, (event)->
		debug "Styles: File #{event.path} was #{event.type}"
		if Config.fingerprint
			Plugins.runsequence 'styles', 'manifest:styles', 'pages'
		else
			Plugins.runsequence 'styles'
	debug "watching styles: #{paths.styles}"

gulp.task 'watch:data', (done)->
	debug 'Starting'
	gulp.watch paths.data, (event)->
		debug "Data: File #{event.path} was #{event.type}"
		Plugins.runsequence 'pages'
	debug "watching data: #{paths.data}"

gulp.task 'watch:copy', (done)->
	debug 'Starting'
	gulp.watch paths.copy, (event)->
		debug "CopyTasks: File #{event.path} was #{event.type}"
		if Config.fingerprint
			Plugins.runsequence 'copy', 'manifest:copy', 'pages'
		else
			Plugins.runsequence 'copy'
	debug "watching copy: #{paths.copy}"

gulp.task 'watch:patterns', (done)->
	debug 'Starting'
	gulp.watch paths.patterns, (event)->
		debug "Patterns: File #{event.path} was #{event.type}"
		Plugins.runsequence 'pages'
	debug "watching patterns: #{paths.patterns}"

gulp.task 'watch:environments', (done)->
	debug 'Starting'
	gulp.watch paths.environments, (event)->
		debug "Environments: File #{event.path} was #{event.type}"
		Plugins.runsequence 'reload-config', 'compile'
	debug "watching environments: #{paths.environments}"
	

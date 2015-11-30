#
# System
path = require 'path'

#
# Framework
_ = require 'lodash'
gulp = require 'gulp'
debug = require('debug')('gastropod/tasks/manifest')
async = require 'async-chainable'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'
Manifest = require '../core/assets/manifest'


#
# Constants
logger = new Logger('manifest')
sources =
	static: path.join(Config.target.root,
			  		  Config.target.static,
			  		  Config.filters.all)

	styles: path.join(Config.target.root,
					  Config.target.static,
					  Config.target.styles,
					  Config.filters.styles)

	scripts: path.join(Config.target.root,
					   Config.target.static,
					   Config.target.scripts,
					   Config.filters.scripts.all)
	copy: do ->
		parts = []
		for task in Config.plugins.copy
			parts.push path.join(Config.target.root,
							     task.dest,
			  					 Config.filters.all)
		return parts

debug 'copy:extras', sources.copy

sources.all = [
	sources.copy
	sources.scripts
	sources.styles
]

target = Config.target.root
basepath = path.join(Config.target.root, Config.target.static)

# set the root for the manifest
# we want this done each run because
# the config file may have changed (thus
# the source of the trigger)
Manifest.option 'root', path.join Config.target.root, Config.target.static


manifestFactory = (source)->
	(done)->

		debug 'source', source
		debug 'target', target
		debug "Starting"

		debug 'current manifest', Object.keys(Manifest.db).length

		return gulp.src source, base: Config.target.root
			.pipe logger.incoming()
			.pipe Plugins.plumber ErrorHandler('manifest')
			.pipe Plugins.clean()
			.pipe Plugins.if Config.fingerprint, Plugins.fingerprint().revision()
			.pipe Plugins.if Config.fingerprint, Plugins.tap Manifest.add
			.pipe logger.outgoing()
			.pipe gulp.dest target
			.on 'error', debug
			.on 'finish', ->
				debug "Finished"

gulp.task 'manifest', manifestFactory(sources.static)

	# async()
	# 	.then (next)->
	# 		debug 'manifest:copy'
	# 		Plugins.runsequence 'manifest:copy', next

	# 	.then (next)->
	# 		debug 'manifest:styles'
	# 		Plugins.runsequence 'manifest:styles', next

	# 	.then (next)->
	# 		debug 'manifest:scripts'
	# 		Plugins.runsequence 'manifest:scripts', next

	# 	.end (err)->
	# 		debug 'manifest:done'
	# 		done()
	# return

gulp.task 'manifest:scripts', manifestFactory(sources.scripts)
gulp.task 'manifest:styles', manifestFactory(sources.styles)
gulp.task 'manifest:copy', manifestFactory(sources.copy)

#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/tasks/manifest')
gulp = require 'gulp'
_ = require 'lodash'

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
	sources.scripts
	sources.styles
	sources.copy
]

target = Config.target.root

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

		# Manifest.empty()

		debug 'new manifest', Manifest

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

gulp.task 'manifest', ['manifest:scripts', 'manifest:styles', 'manifest:copy']
gulp.task 'manifest:scripts', manifestFactory(sources.scripts)
gulp.task 'manifest:styles', manifestFactory(sources.styles)
gulp.task 'manifest:copy', manifestFactory(sources.copy)

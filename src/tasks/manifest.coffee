#
# System
path = require 'path'

#
# Framework
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/manifest')
gulp = require 'gulp'
async = require 'async-chainable'
vinylPaths = require 'vinyl-paths'
del = require 'del'
Q = require 'bluebird'
through = require 'through2'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'
Manifest = require '../core/assets/manifest'


#
# Constants
sources =
	root: path.join(Config.target.root,
					Config.target.static)

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


target = path.join(Config.target.root, Config.target.static)


# set the root for the manifest
# we want this done each run because
# the config file may have changed (thus
# the source of the trigger)
Manifest.option 'root', path.join Config.target.root, Config.target.static

Urls = Config.context.site.urls


manifestFactory = (name, source)->
	logPrefix = "Manifest[#{name}]"
	logger = new Logger(logPrefix)
	handleErrors = ErrorHandler(logPrefix)

	return (done)->

		debug 'source', source
		debug 'target', target
		debug "Starting"
		debug "current manifest contains #{Object.keys(Manifest.db).length} objects"


		fingerprinter = Plugins.fingerprint()
		vinyl = vinylPaths()

		return gulp.src source, base: sources.root
			.pipe logger.incoming()
			.pipe vinyl
			.pipe Plugins.plumber handleErrors
			.pipe Plugins.if Config.fingerprint, fingerprinter.revision()
			.pipe Plugins.if Config.fingerprint, Plugins.tap Manifest.add
			.pipe logger.outgoing()
			.pipe gulp.dest target
			.on 'finish', -> debug "Finished"
			.on 'end', ->
				debug "deleting originals:", vinyl.paths
				return del(vinyl.paths)

gulp.task 'manifest', manifestFactory('all', sources.static)
gulp.task 'manifest:scripts', manifestFactory('scripts', sources.scripts)
gulp.task 'manifest:styles', manifestFactory('styles', sources.styles)
gulp.task 'manifest:copy', manifestFactory('copy', sources.copy)

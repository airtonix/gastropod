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

	all: path.join(Config.target.root, Config.target.static, Config.filters.all)


sources.all = [
	sources.copy
	sources.scripts
	sources.styles
]


target = path.join(Config.target.root, Config.target.static)


# set the root for the manifest
# we want this done each run because
# the config file may have changed (thus
# the source of the trigger)
Manifest.option 'root', path.join Config.target.root, Config.target.static

Urls = Config.context.site.urls


manifestFactory = (source)->
	(done)->

		debug 'source', source
		debug 'target', target
		debug "Starting"

		Manifest.empty()

		debug "current manifest contains #{Object.keys(Manifest.db).length} objects"

		return new Q (resolve, reject)->

			vinylPathsPipe = vinylPaths()

			return gulp.src source
				.pipe logger.incoming()
				.pipe Plugins.plumber ErrorHandler('manifest')
				.pipe vinylPathsPipe
				.pipe Plugins.if Config.fingerprint, Plugins.fingerprint.revision()
				.pipe Plugins.if Config.fingerprint, Plugins.tap Manifest.add
				.pipe logger.outgoing()
				.pipe gulp.dest target
				# .pipe Plugins.if Config.fingerprint, Plugins.fingerprint.manifestFile()
				# .pipe gulp.dest target
				.on 'end', ->
					del vinylPathsPipe.paths
						.then resolve
						.catch reject
				.on 'error', debug
				.on 'finish', -> debug "Finished"

gulp.task 'manifest', manifestFactory(sources.static)
gulp.task 'manifest:scripts', manifestFactory(sources.scripts)
gulp.task 'manifest:styles', manifestFactory(sources.styles)
gulp.task 'manifest:copy', manifestFactory(sources.copy)

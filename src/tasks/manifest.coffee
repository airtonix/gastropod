#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/tasks/manifest')
gulp = require 'gulp'
revAll = require 'gulp-rev-all'
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

	all: path.join(Config.target.root, Config.target.static, Config.filters.all)

debug 'copy:extras', sources.copy


target = path.join Config.target.root, Config.target.static

# set the root for the manifest
# we want this done each run because
# the config file may have changed (thus
# the source of the trigger)
Manifest.option 'root', path.join Config.target.root, Config.target.static

Urls = Config.context.site.urls
Fingerprint = new revAll
	debug: true
	prefix: path.join Urls.root, Urls.static

manifestFactory = (source)->
	(done)->

		debug 'source', source
		debug 'target', target
		debug "Starting"

		# Manifest.empty()

		debug 'new manifest', Manifest

		return gulp.src source
			.pipe logger.incoming()
			.pipe Plugins.plumber ErrorHandler('manifest')
			.pipe Plugins.clean()
			.pipe Plugins.if Config.fingerprint, Fingerprint.revision()
			.pipe Plugins.if Config.fingerprint, Plugins.tap Manifest.add
			.pipe logger.outgoing()
			.pipe gulp.dest target
			.pipe Plugins.if Config.fingerprint, Fingerprint.manifestFile()
			.pipe gulp.dest target
			.on 'error', debug
			.on 'finish', ->
				debug "Finished"

gulp.task 'manifest', manifestFactory(sources.all)
gulp.task 'manifest:scripts', manifestFactory(sources.scripts)
gulp.task 'manifest:styles', manifestFactory(sources.styles)
gulp.task 'manifest:copy', manifestFactory(sources.copy)

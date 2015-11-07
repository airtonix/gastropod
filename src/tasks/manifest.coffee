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
sources = [
		path.join(Config.target.root
				  Config.target.static,
				  Config.target.images
				  Config.filters.images)

		path.join(Config.target.root
				  Config.target.static,
				  Config.target.fonts
				  Config.filters.fonts)

		path.join(Config.target.root
				  Config.target.static,
				  Config.target.styles
				  Config.filters.styles)

		path.join(Config.target.root
				  Config.target.static,
				  Config.target.scripts
				  Config.filters.scripts.all)
	]

target = Config.target.root

# set the root for the manifest
# we want this done each run because
# the config file may have changed (thus
# the source of the trigger)
Manifest.option 'root', path.join Config.target.root, Config.target.static


gulp.task 'manifest', (done)->

	debug 'sources', sources
	debug 'target', target
	debug "Starting"

	Manifest.empty()

	debug 'new manifest', Manifest

	return gulp.src sources, base: Config.target.root
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('manifest')
		.pipe Plugins.clean()
		.pipe Plugins.fingerprint().revision()
		.pipe Plugins.tap Manifest.add
		.pipe logger.outgoing()
		.pipe gulp.dest target
		.on 'error', debug
		.on 'finish', ->
			debug "Finished"

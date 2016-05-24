
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/scripts:browserify')
gulp = require 'gulp'

#
# Project
Config = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'

#
# Constants
logger = new Logger('scripts:browserify')
source = path.join(Config.Store.source.root,
				   Config.Store.source.scripts,
				   Config.Store.filters.scripts.modules)
target = path.join(Config.Store.target.root,
				   Config.Store.target.static,
				   Config.Store.target.scripts)
browserifyConfig = Config.Store.plugins.js.browserify
transforms = browserifyConfig.transforms


gulp.task 'browserify', (done)->
	debug "Starting"
	debug " > source", source
	debug " > target", target

	return gulp.src source
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('scripts:browserify')
		.pipe Plugins.through.obj (file, env, next)->

			browserify = Plugins.browserify file.path, browserifyConfig

			for plugin, options in transforms
				if plugin of Plugins
					transform = Plugins[plugin]
					browserify.transform transform.apply options

			browserify.bundle (err, results)->
				debug 'processed %s', file.relative
				if err
					file.contents = null
					next err, file
				else
					file.contents = results
					next(null, file)

		.pipe Plugins.rename
			extname: '.js'
		.pipe gulp.dest target
		.pipe Plugins.browsersync.stream()
		.pipe logger.outgoing()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished"

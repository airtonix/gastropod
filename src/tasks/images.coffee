
#
# System
#
path = require 'path'

#
# Framework
#
debug = require('debug')('gastropod/tasks/images')
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'

#
# Constants
logger = new Logger('images')
source = path.join(Config.source.root,
				   Config.source.images,
				   Config.filters.images)
target = path.join(Config.target.root,
				   Config.target.static,
				   Config.target.images)


gulp.task 'copy:images', (done)->
	debug "Starting"
	debug " > source", source
	debug " > target", target

	return gulp.src source #, base: Config.source.images
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('images')
		.pipe Plugins.imagemin()
		.pipe gulp.dest target
		.pipe logger.outgoing()
		.pipe Plugins.browsersync.stream()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished"

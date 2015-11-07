
#
# System
#
path = require 'path'

#
# Framework
#
debug = require('debug')('gastropod/tasks/styles')
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'


logger = new Logger('styles')
source = path.join(Config.source.root,
				   Config.source.styles,
				   Config.filters.styles)
target = path.join(Config.target.root,
				   Config.target.static,
				   Config.target.styles)


gulp.task 'scss', (done)->
	debug "Starting"
	debug " > source", source
	debug " > target", target

	return gulp.src source
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('Styles')
		.pipe Plugins.sass(Config.plugins.sass)
		.pipe logger.outgoing()
		.pipe gulp.dest target
		.pipe Plugins.browsersync.stream()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished"

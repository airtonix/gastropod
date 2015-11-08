
#
# System
#
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/tasks/copy')
async = require 'async-chainable'
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'

#
# Constants
logger = new Logger('copy')


gulp.task 'copy:extras', (done)->
	debug "Starting", Config.plugins.copy
	done() unless Config.plugins.copy?

	Stream = Plugins.merge()

	Config.plugins.copy.map (task)->
		source = path.join(process.cwd(),
						    Config.source.root,
						    task.src)

		target = path.join(process.cwd(),
						   Config.target.root,
						   task.dest)

		debug " > source", source
		debug " > target", target

		taskStream = gulp.src source
			.pipe logger.incoming()
			.pipe Plugins.plumber ErrorHandler("Copy: #{task.src}")
			.pipe gulp.dest target
			.pipe logger.outgoing()
			.pipe Plugins.browsersync.stream()
			.on 'error', (err)-> debug err
			.on 'finish', ()-> debug "Finished #{task.src}"

		Stream.add taskStream


	return Stream
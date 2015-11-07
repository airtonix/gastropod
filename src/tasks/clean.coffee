
#
# System
#
path = require 'path'

#
# Framework
#
debug = require('debug')('gastropod/tasks/clean')
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'

gulp.task 'clean:scripts', (done)->
	logger = new Logger('clean:scripts')
	source = path.join(Config.target.root,
					   Config.target.static,
					   Config.target.scripts,
					   Config.filters.scripts.all)

	debug 'source', source
	debug "Starting"

	return gulp.src source, read: false
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('clean:scripts')
		.pipe Plugins.clean()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished: scripts"


gulp.task 'clean:styles', (done)->
	logger = new Logger('clean:styles')
	source = path.join(Config.target.root,
					   Config.target.static,
					   Config.target.styles,
					   Config.filters.styles)

	debug 'source', source
	debug "Starting"

	return gulp.src source, read: false
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('clean:styles')
		.pipe Plugins.clean()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished: styles"


cleanLogger = new Logger('clean:copies')
gulp.task 'clean:copies', (done)->
	debug 'enter', Config.plugins.copy
	if not Config.plugins.copy
		debug 'Nothing to copy!'
		done()
	else
		debug "Starting: copies"

	Stream = Plugins.merge()

	Config.plugins.copy.map (task)->
		source = path.join(process.cwd(),
						   Config.target.root,
						   task.dest)

		debug "copies: > source", source

		taskStream = gulp.src source, read: false
			.pipe cleanLogger.incoming()
			.pipe Plugins.plumber ErrorHandler('clean:copy')
			.pipe Plugins.clean()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished: clean:copy"

		Stream.add taskStream

	return Stream

gulp.task 'clean:pages', (done)->
	logger = new Logger('clean:pages')
	source = path.join(Config.target.root,
						 Config.target.pages,
						 Config.filters.patterns)

	debug 'source', source
	debug "Starting"

	return gulp.src source, read: false
		.pipe Plugins.plumber ErrorHandler('clean:pages')
		.pipe logger.incoming()
		.pipe Plugins.clean()
		.on 'error', (err)-> debug err
		.on 'end', ()->
			debug "Finished: pages"

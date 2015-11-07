
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


gulp.task 'clean:images', (done)->
	logger = new Logger('clean:images')
	source = path.join(Config.target.root,
					   Config.target.static,
						 Config.target.images,
						 Config.filters.images)

	debug 'source', source
	debug "Starting"

	return gulp.src source, read: false
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('clean:images')
		.pipe Plugins.clean()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished: images"


gulp.task 'clean:copies', (done)->
	logger = new Logger('clean:copies')
	debug "Starting"

	for task in Config.copy
		source = path.join(process.cwd(),
						   Config.source.root,
						   task.dest)

		debug " > source", source

		return gulp.src source, read: false
			.pipe logger.incoming()
			.pipe Plugins.plumber ErrorHandler('clean:copy')
			.pipe Plugins.clean()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished: clean:copy"


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

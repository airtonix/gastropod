
#
# System
#
path = require 'path'

#
# Framework
#
debug = require('debug')('gastropod/tasks/clean')
gulp = require 'gulp'
del = require 'del'
vinylPaths = require 'vinyl-paths'
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
					   Config.filters.all)

	debug 'scripts: > source', source
	debug "Starting: Scripts"

	return gulp.src source, read: false
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('clean:scripts')
		.pipe vinylPaths(del)
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished: scripts"


gulp.task 'clean:styles', (done)->
	logger = new Logger('clean:styles')
	source = path.join(Config.target.root,
					   Config.target.static,
					   Config.target.styles,
					   Config.filters.all)

	debug 'styles: > source', source
	debug "Starting: styles"

	return gulp.src source, read: false
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('clean:styles')
		.pipe vinylPaths(del)
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished: styles"


cleanLogger = new Logger('clean:copies')
gulp.task 'clean:copies', (done)->
	debug 'enter: copies >', Config.plugins.copy
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
			.pipe vinylPaths(del)
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished: clean:copy [#{source}]"

		Stream.add taskStream
		return

	return Stream

gulp.task 'clean:pages', (done)->
	logger = new Logger('clean:pages')
	source = [
		path.join(Config.target.root, Config.target.pages, Config.filters.all)
		"!#{path.join Config.target.root, Config.target.static, Config.target.styles}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.scripts}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.fonts}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.images}{,/**}"
	]

	debug 'pages: > source', source
	debug "Starting: pages"

	return gulp.src source, read: false
		.pipe Plugins.plumber ErrorHandler('clean:pages')
		.pipe logger.incoming()
		.pipe vinylPaths(del)
		.on 'error', (err)-> debug err
		.on 'end', ()->
			debug "Finished: pages"

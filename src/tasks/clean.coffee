
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
Q = require 'bluebird'


#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'


gulp.task 'clean:scripts', (done)->
	sources = []
	sources.push path.join(Config.target.root,
					   Config.target.static,
					   Config.target.scripts,
					   Config.filters.all)

	debug 'scripts: > sources', sources
	debug "Starting: Scripts"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug 'Finished: clean:scripts'
			.then( ()=> resolve())
			.catch(reject)
		return

gulp.task 'clean:styles', (done)->
	sources = []
	sources.push path.join(Config.target.root,
					   Config.target.static,
					   Config.target.styles,
					   Config.filters.all)

	debug 'styles: > sources', sources
	debug "Starting: styles"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug 'Finished: clean:styles'
			.then(resolve)
			.catch(reject)
		return


gulp.task 'clean:copies', (done)->
	debug 'enter: copies >', Config.plugins.copy
	if not Config.plugins.copy
		debug 'Nothing to copy!'
		done()
	else
		debug "Starting: copies"

	sources = Config.plugins.copy.map (task)->
		debug 'building copy source', task.dest
		source = path.join(process.cwd(),
						   Config.target.root,
						   task.dest)

		debug "copies: > sources", source
		return source

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug 'Finished: clean:copies'
			.then(resolve)
			.catch(reject)
		return

gulp.task 'clean:docs', (done)->
	sources = []
	sources.push path.join(Config.target.root,
					   Config.target.static,
					   Config.target.docs,
					   Config.filters.all)

	debug 'documentation: > sources', sources
	debug "Starting: documentation"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug 'Finished: clean:documentation'
			.then(resolve)
			.catch(reject)
		return


gulp.task 'clean:pages', (done)->
	sources = [
		path.join(Config.target.root, Config.target.pages, Config.filters.all)
		"!#{path.join Config.target.root, Config.target.static, Config.target.styles}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.scripts}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.fonts}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.fonts}{,/**}"
		"!#{path.join Config.target.root, Config.target.static, Config.target.docs}{,/**}"
	]

	debug 'pages: > sources', sources
	debug "Starting: pages"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug 'Finished: clean:pages'
			.then(resolve)
			.catch(reject)
		return


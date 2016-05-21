
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
_ = require 'lodash'
Q = require 'bluebird'


#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'


gulp.task 'clean:scripts', (done)->
	sources = []
	sources.push path.join(Config.Store.target.root,
					   Config.Store.target.static,
					   Config.Store.target.scripts,
					   Config.Store.filters.all)

	debug 'scripts: > sources', sources
	debug "Starting: Scripts"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug "Finished: clean:scripts #{paths.length} files"
				( debug("> Cleaned #{file}") for file in paths)
				resolve()
				return

			.catch (err)->
				debug 'Error: clean:scripts', err
				reject(err)
				return

		return

gulp.task 'clean:styles', (done)->
	sources = []
	sources.push path.join(Config.Store.target.root,
					   Config.Store.target.static,
					   Config.Store.target.styles,
					   Config.Store.filters.all)

	debug 'styles: > sources', sources
	debug "Starting: styles"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug "Finished: clean:styles #{paths.length} files"
				( debug("> Cleaned #{file}") for file in paths)
				resolve()
				return

			.catch (err)->
				debug 'Error: clean:styles', err
				reject(err)
				return

		return


gulp.task 'clean:copies', (done)->
	debug 'enter: copies >', Config.Store.plugins.copy
	if not Config.Store.plugins.copy
		debug 'Nothing to copy!'
		done()
	else
		debug "Starting: copies"

	sources = Config.Store.plugins.copy.map (task)->
		debug 'building copy source', task.dest
		source = path.join(process.cwd(),
						   Config.Store.target.root,
						   task.dest)

		debug "copies: > sources", source
		return source

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug "Finished: clean:copies #{paths.length} files"
				resolve()
				return

			.catch (err)->
				debug 'Error: clean:copies', err
				reject(err)
				return
		return

gulp.task 'clean:docs', (done)->
	sources = []
	sources.push path.join(Config.Store.target.root,
					   Config.Store.target.static,
					   Config.Store.target.docs,
					   Config.Store.filters.all)

	debug 'documentation: > sources', sources
	debug "Starting: documentation"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug "Finished: clean:documentation #{paths.length} files"
				resolve()
				return
			.catch (err)->
				debug 'Error: clean:documentation', err
				reject(err)
				return
		return


gulp.task 'clean:pages', (done)->
	sources = [
		path.join(Config.Store.target.root, Config.Store.target.pages, Config.Store.filters.all)
		"!#{path.join Config.Store.target.root, Config.Store.target.static}"
		"!#{path.join Config.Store.target.root, Config.Store.target.static}/**"
	]
	for bit in Config.Store.plugins.copy
		bitPath = path.join Config.Store.target.root, bit.dest
		debug 'bitPath', bitPath
		sources.push "!#{bitPath}"
		sources.push "!#{bitPath}/**"

	for bit in Config.Store.plugins.copy
		debug 'Ignoring copy paths:', bit.dest

		sources.push "!#{path.join Config.Store.target.root, bit.dest}"
		sources.push "!#{path.join Config.Store.target.root, bit.dest}/**"


	debug 'pages: > sources', sources
	debug "Starting: pages"

	return new Q (resolve, reject)->
		del(sources)
			.then (paths)->
				debug "Finished: clean:pages #{paths.length} files"
				( debug("> Cleaned #{file}") for file in paths)
				resolve()
				return

			.catch (err)->
				debug 'Error: clean:pages', err
				reject(err)
				return

		return

#
# System
#
path = require 'path'

#
# Framework
#
debug = require('debug')('gastropod/tasks/pages:jade')
jade = require 'jade'
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'
Manifest = require '../core/assets/manifest'
Context = require '../core/templates/context'

#
# Constants
logger = new Logger('pages:jade')
pages = path.join(Config.source.root,
			  	  Config.source.pages)
root = path.resolve(process.cwd(),
			  		Config.source.patterns[0])
projectGlobalDataRoot = path.join(process.cwd(),
				 				  Config.source.root,
				 				  Config.source.data)
sources = [
	path.join(pages, Config.filters.all)
	'!**/*.coffee'
]
target = path.join Config.target.root, '/'


gulp.task 'jade', (done)->
	Context.empty()
	Context.add require globalSource
	Context.add manifest: Manifest

	debug "Starting"
	debug " > source", source
	debug " > target", target

	return gulp.src source
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('pages:jade')
		.pipe Plugins.frontMatter
			property: 'meta'
			remove: true
		.pipe Plugins.data Context.export
		.pipe Plugins.jade basedir: patterns
		.pipe gulp.dest target
		.pipe Plugins.browsersync.stream()
		.pipe logger.outgoing()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished"

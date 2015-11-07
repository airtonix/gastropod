
#
# System
#
path = require 'path'

#
# Framework
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/pages:swig')
deepmerge = require 'deepmerge'
postmortem = require 'postmortem'
requireUncached = require 'require-uncached'
async = require 'async-chainable'
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'
Templates = require '../core/templates'
Manifest = require '../core/assets/manifest'
SwigConfig = require '../core/templates/swig/configurator'
Context	= require '../core/templates/context'

#
# Constants
logger = new Logger('pages:swig')

pages = path.join(Config.source.root,
			  	  Config.source.pages)
root = path.resolve(process.cwd(),
			  		Config.source.patterns[0])
sources = [
	path.join(pages, Config.filters.all)
	'!**/*.coffee'
]
target = path.join Config.target.root, '/'

SwigConfig.configure(sources: root)

debug 'SwigConfig.tags', SwigConfig.tags
debug 'SwigConfig.filters', SwigConfig.filters

gulp.task 'swig', (done)->

	Context.prepare()

	gulp.src sources
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('pages')
		.pipe Plugins.frontMatter
			property: 'meta'
			remove: true
		.pipe Plugins.data Context.export
		.pipe Plugins.swig SwigConfig
		.pipe Plugins.if Config.plugins.prettify, Plugins.removeEmptyLines()
		.pipe Plugins.if Config.plugins.prettify, Plugins.htmlPrettify Config.plugins.prettify
		.pipe logger.outgoing()
		.pipe gulp.dest target
		.pipe Plugins.browsersync.stream()
		.on 'finish', -> debug "Finished"

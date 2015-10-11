
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

#
# Project
#
async = require 'async-chainable'
Configurator = require '../core/swig/configurator'
ContentCollection = require '../core/content'
ContextFactory = require '../core/templates/context'
debug = require('debug')('gastropod/tasks/pages:swig')
deepmerge = require 'deepmerge'
ErrorHandler = require '../core/logging/errors'
Files = require '../core/utils/files'
Logger = require '../core/logging/logger'
Manifest = require '../core/assets/manifest'
postmortem = require 'postmortem'
requireUncached = require 'require-uncached'


module.exports = (gulp, $, config)->

	###*
	 * Templates
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'swig', ['manifest'], (done)->
		logger = new Logger('pages:swig')

		root = path.join(config.source.root,
						 config.source.patterns)

		pages = path.join(config.source.root,
					  	  config.source.pages)

		data = path.join(process.cwd(),
						 config.source.root,
						 config.source.data)

		sources = [
			path.join(pages, config.filters.all)
			'!**/*.coffee'
		]

		target = path.join config.target.root, '/'

		SwigConfig = new Configurator(root: root)
		TemplateContext = new ContextFactory({})
		TemplateHash = new Files(pattern='**', options=root, ignore=['pages/*'])

		debug 'Populating Global Context'
		# add fingerprinted asset manifest

		TemplateContext.add Manifest: Manifest.db
		# add template hashmap
		TemplateContext.add Templates: TemplateHash
		# add Project level global context
		TemplateContext.add requireUncached(data)(TemplateContext.data)
		# add Environment level global context
		TemplateContext.add config.context

		debug 'sources', sources
		debug 'target', target
		debug "Starting"

		return gulp.src sources
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('pages')
			.pipe $.tap (file, tap)->
				debug 'Manifest.db', Manifest.db['styles/screen.css']
			.pipe $.frontMatter
				property: 'meta'
				remove: true
			.pipe $.data TemplateContext.export
			.pipe $.swig SwigConfig
			.pipe $.if config.plugins.prettify, $.removeEmptyLines()
			.pipe $.if config.plugins.prettify, $.htmlPrettify config.plugins.prettify
			.pipe logger.outgoing()
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'end', ()->
				debug "Finished"

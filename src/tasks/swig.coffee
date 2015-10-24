
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
{pongular} = require 'pongular'
async = require 'async-chainable'

#
# Exportable
pongular.module 'gastropod.tasks.swig', [
	'gastropod.vendor.gulp'
	'gastropod.core.logging'
	'gastropod.core.utils'
	'gastropod.core.content'
	'gastropod.core.templates'
	'gastropod.plugins'
	'gastropod.config'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		'ContextService'
		'ContentService'
		'SwigConfig'
		'FileService'
		'ErrorHandler'
		'Logger'
		(Gulp, Plugins, Config, Context, Content, SwigConfig, FileService, ErrorHandler, Logger)->
			###*
			 * Templates
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			logger = new Logger('pages:swig')

			pages = path.join(Config.source.root,
						  	  Config.source.pages)

			root = path.join(Config.source.root,
						  	 Config.source.patterns[0])

			projectGlobalDataRoot = path.join(process.cwd(),
							 				  Config.source.root,
							 				  Config.source.data)
			sources = [
				path.join(pages, Config.filters.all)
				'!**/*.coffee'
			]

			patterns = _.map Config.source.patterns, (source)->
				relative = path.relative process.cwd(), source
				resolved = path.resolve relative, process.cwd()
				debug 'relative', source, relative, resolved
				return relative

			target = path.join Config.target.root, '/'
			SwigConfig = SwigConfig.configure(sources: patterns)

			Gulp.task 'swig', (done)->
				# Load data files from project
				# @TODO how to force load existing pongular modules
				load(dirname: pages, filter: /(.+)\.[js|coffee|litcoffee]+$/)

				#async()
				# 	.forEach Object.keys(globalDataModules), (name, next)->
				# 		TemplateContext.ioc.resolve name, (data)->
				# 			obj = {}
				# 			obj[name] = data
				# 			TemplateContext.add obj
				# 			next()

				#	.then (next)->
				# 		# add Environment level global context
				# 		TemplateContext.add Config.context
				#		next()

				#	.end (err)->
				# 		debug 'sources', sources
				# 		debug 'target', target
				# 		debug "Starting"

				# 		return Gulp.src sources
				# 			.pipe logger.incoming()
				# 			.pipe Plugins.plumber ErrorHandler('pages')
				# 			.pipe Plugins.frontMatter
				# 				property: 'meta'
				# 				remove: true
				# 			.pipe Plugins.data TemplateContext.export
				# 			.pipe Plugins.swig SwigConfig
				# 			.pipe Plugins.if Config.plugins.prettify, Plugins.removeEmptyLines()
				# 			.pipe Plugins.if Config.plugins.prettify, Plugins.htmlPrettify Config.plugins.prettify
				# 			.pipe logger.outgoing()
				# 			.pipe Gulp.dest target
				# 			.pipe Plugins.browsersync.stream()
				# 			.on 'finish', ()-> debug "Finished"
				done()
	]
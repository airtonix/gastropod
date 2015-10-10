
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
ErrorHandler = require '../core/logging/errors'
Logger = require '../core/logging/logger'
debug = require('debug')('gastropod/tasks/pages:swig')
ContextFactory = require '../core/templates/context'
Configurator = require '../core/swig/configurator'
Manifest = require '../core/assets/manifest'
Files = require '../core/utils/files'
deepmerge = require 'deepmerge'


module.exports = (gulp, $, config)->

	###*
	 * Templates
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'swig', (done)->
		logger = new Logger('pages:swig')

		root = path.join(config.source.root,
						 config.source.patterns)

		data = path.join(process.cwd(),
						 config.source.root,
						 config.source.data)

		sources = [
			path.join(config.source.root,
					  config.source.pages,
					  config.filters.all)

			'!**/*.coffee'
		]
		target = path.join config.target.root, '/'

		# remove cached version of global data
		# because we want a fresh copy every time.
		# @TODO: this needs closer attention... doesn't seem to be working
		delete require.cache[require.resolve(data)]

		#
		# Template HashMap
		#
		# make a hashmap of project templates
		templates = new Files(pattern='**', options=root, ignore=['pages/*'])
		# @TODO: make a list of templates from gastropod modules that provide templates
		# for addon in gastropod.addons where 'templates' in addon.provides
		#	templates = deepmerge {}, templates

		#
		# Page Context
		#
		Context = new ContextFactory()
		# add fingerprinted asset manifest
		Context.add manifest: Manifest.db
		# add template hashmap
		Context.add templates: templates
		# merge in project level global context.
		Context.add deepmerge config.context, require(data)(Context.data)

		#
		# Swig Config
		#
		SwigConfiguration = new Configurator root: root

		debug 'sources', sources
		debug 'target', target
		debug "Starting"

		return gulp.src sources
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('pages')
			.pipe $.frontMatter
				property: 'meta'
				remove: true
			.pipe $.data Context.export
			.pipe $.swig SwigConfiguration
			.pipe $.removeEmptyLines()
			.pipe $.htmlPrettify()
			.pipe logger.outgoing()
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'end', ()-> debug "Finished"

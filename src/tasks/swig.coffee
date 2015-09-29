
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

		delete require.cache[require.resolve(data)]
		globals = require data

		Context = new ContextFactory()
		Context.add deepmerge globals, config.context
		Context.add manifest: Manifest.db
		Context.add templates: new Files(pattern='**', options=root, ignore=['pages/*'])

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
			.pipe gulp.dest target
			.pipe logger.outgoing()
			.pipe $.browsersync.stream()
			.on 'end', ()-> debug "Finished"

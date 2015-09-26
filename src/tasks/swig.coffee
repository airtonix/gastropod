
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
debug = require('debug')('gastropod/tasks/pages')
ContextFactory = require '../core/swig/context'
Configurator = require '../core/swig/configurator'
Manifest = require '../core/assets/manifest'


module.exports = (gulp, $, config)->

	###*
	 * Templates
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'swig', (done)->
		source = path.join(config.source.root,
							 config.source.pages,
							 config.filters.patterns)

		target = path.join config.target.root, '/'

		TemplateContext = new ContextFactory()
		SwigConfiguration = new Configurator
			root: source
			globals:
				manifest: Manifest.db

		debug 'source', source
		debug 'target', target
		debug 'swig.Config', SwigConfiguration

		gulp.src source
			.pipe $.plumber ErrorHandler('pages')
			.pipe $.frontMatter
				property: 'meta'
				remove: true
			.pipe $.data TemplateContext.export
			.pipe $.swig SwigConfiguration
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'error', (err)-> debug err


#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
jade = require 'jade'
debug = require('debug')('gastropod/tasks/pages:jade')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.jade', [
	'gastropod.vendor.gulp'
	'gastropod.core.logging'
	'gastropod.plugins'
	'gastropod.config'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		'ManifestStore'
		'ContextService'
		'ErrorHandler'
		'Logger'
		(Gulp, Plugins, Config, Manifest, Context, ErrorHandler, Logger)->

			###*
			 * Templates
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'jade', (done)->
				logger = new Logger('pages:jade')
				source = path.join(Config.source.root,
								   Config.source.pages,
								   Config.filters.patterns)

				patterns = path.join(process.cwd(),
									 Config.source.root,
								     Config.source.patterns)

				globals = path.join(process.cwd(),
									Config.source.root,
								    Config.source.data)

				target = path.join Config.target.root, '/'

				Context.empty()
				Context.add require globals
				Context.add manifest: Manifest

				debug 'source', source
				debug 'target', target

				debug "Starting"

				return Gulp.src source
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('pages:jade')
					.pipe Plugins.frontMatter
						property: 'meta'
						remove: true
					.pipe Plugins.data Context.export
					.pipe Plugins.jade basedir: patterns
					.pipe Gulp.dest target
					.pipe Plugins.browsersync.stream()
					.pipe logger.outgoing()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"
	]
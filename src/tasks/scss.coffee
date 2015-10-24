
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/styles')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.scss', [
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

			logger = new Logger('styles')

			###*
			 * Style Sheets
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'scss', (done)->

				source = path.join(Config.source.root,
								   Config.source.styles,
								   Config.filters.styles)

				target = path.join(Config.target.root,
								   Config.target.static,
								   Config.target.styles)

				debug 'source', source
				debug 'target', target
				debug "Starting"

				return Gulp.src source
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('Styles')
					.pipe Plugins.sass(Config.plugins.sass)
					.pipe logger.outgoing()
					.pipe Gulp.dest target
					.pipe Plugins.browsersync.stream()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"
	]
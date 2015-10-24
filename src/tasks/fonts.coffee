
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

#
# Projects
#
debug = require('debug')('gastropod/tasks/fonts')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.fonts', [
	'gastropod.vendor.gulp'
	'gastropod.core.logging'
	'gastropod.plugins'
	'gastropod.config'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		'ErrorHandler'
		'Logger'
		(Gulp, Plugins, Config, ErrorHandler, Logger)->

			###*
			 * Fonts
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'copy:fonts', (done)->
				logger = new Logger('fonts')
				sources = [
					path.join(process.cwd(),
							  Config.source.root,
							  Config.source.fonts.internal,
							  Config.filters.fonts)

					path.join(process.cwd(),
							  Config.source.fonts.vendor,
							  Config.filters.fonts)
				]
				target = path.join(Config.target.root,
								   Config.target.static,
								   Config.target.fonts)

				debug 'sources', sources
				debug 'target', target
				debug "Starting"

				return Gulp.src sources
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('fonts')
					.pipe Gulp.dest target
					.pipe logger.outgoing()
					.pipe Plugins.browsersync.stream()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"
	]
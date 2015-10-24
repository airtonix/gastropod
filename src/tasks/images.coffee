
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/images')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.images', [
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
			 * Images
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'copy:images', (done)->
				logger = new Logger('images')
				source = path.join(Config.source.root,
									 Config.source.images,
									 Config.filters.images)

				target = path.join(Config.target.root,
								   Config.target.static,
								   Config.target.images)

				debug 'source', source
				debug 'target', target
				debug "Starting"

				return Gulp.src source #, base: Config.source.images
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('images')
					.pipe Plugins.imagemin()
					.pipe Gulp.dest target
					.pipe logger.outgoing()
					.pipe Plugins.browsersync.stream()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"
	]
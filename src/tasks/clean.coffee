
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/clean')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.clean', [
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

			Gulp.task 'clean:scripts', (done)->
				logger = new Logger('clean:scripts')
				source = path.join(Config.target.root,
								   Config.target.static,
								   Config.target.scripts,
								   Config.filters.scripts.all)

				debug 'source', source
				debug "Starting"

				return Gulp.src source, read: false
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('clean:scripts')
					.pipe Plugins.clean()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished: scripts"


			Gulp.task 'clean:styles', (done)->
				logger = new Logger('clean:styles')
				source = path.join(Config.target.root,
								   Config.target.static,
									 Config.target.styles,
									 Config.filters.styles)

				debug 'source', source
				debug "Starting"

				return Gulp.src source, read: false
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('clean:styles')
					.pipe Plugins.clean()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished: styles"


			Gulp.task 'clean:images', (done)->
				logger = new Logger('clean:images')
				source = path.join(Config.target.root,
								   Config.target.static,
									 Config.target.images,
									 Config.filters.images)

				debug 'source', source
				debug "Starting"

				return Gulp.src source, read: false
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('clean:images')
					.pipe Plugins.clean()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished: images"


			Gulp.task 'clean:fonts', (done)->
				logger = new Logger('clean:fonts')
				source = path.join(Config.target.root,
								   Config.target.static,
									 Config.target.fonts,
									 Config.filters.fonts)

				debug 'source', source
				debug "Starting"

				return Gulp.src source, read: false
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('clean:fonts')
					.pipe Plugins.clean()
					.on 'error', (err)-> debug err
					.on 'end', ()-> debug "Finished: fonts"


			Gulp.task 'clean:pages', (done)->
				logger = new Logger('clean:pages')
				source = path.join(Config.target.root,
									 Config.target.pages,
									 Config.filters.patterns)

				debug 'source', source
				debug "Starting"

				return Gulp.src source, read: false
					.pipe Plugins.plumber ErrorHandler('clean:pages')
					.pipe logger.incoming()
					.pipe Plugins.clean()
					.on 'error', (err)-> debug err
					.on 'end', ()->
						debug "Finished: pages"
	]
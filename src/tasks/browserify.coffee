
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/scripts:browserify')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.browserify', [
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
			 * Scripts
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'browserify', (done)->
				logger = new Logger('scripts:browserify')

				source = path.join(Config.source.root,
								   Config.source.scripts,
								   Config.filters.scripts.modules)

				target = path.join(Config.target.root,
								   Config.target.static,
								   Config.target.scripts)

				browserifyConfig = Config.plugins.js.browserify
				transforms = browserifyConfig.transforms

				debug "Starting"
				debug " > source", source
				debug " > target", target

				return Gulp.src source
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('scripts:browserify')
					.pipe Plugins.through.obj (file, env, next)->

						browserify = Plugins.browserify file.path, browserifyConfig

						for plugin, options in transforms
							if plugin of Plugins
								transform = Plugins[plugin]
								browserify.transform transform.apply options

						browserify.bundle (err, results)->
							debug 'processed %s', file.relative
							if err
								file.contents = null
								next err, file
							else
								file.contents = results
								next(null, file)

					.pipe Plugins.rename
						extname: '.js'
					.pipe Gulp.dest target
					.pipe Plugins.browsersync.stream()
					.pipe logger.outgoing()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"

	]
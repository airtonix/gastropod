
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/tasks/manifest')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.manifest', [
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
			 * Generate Manifest
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'manifest', (done)->
				logger = new Logger('manifest')

				# set the root for the manifest
				# we want this done each run because
				# the config file may have changed (thus
				# the source of the trigger)
				Manifest.option 'root', path.join Config.target.root, Config.target.static

				sources = [
						path.join(Config.target.root
								Config.target.static,
								Config.target.images
								Config.filters.images)

						path.join(Config.target.root
								Config.target.static,
								Config.target.fonts
								Config.filters.fonts)

						path.join(Config.target.root
								Config.target.static,
								Config.target.styles
								Config.filters.styles)

						path.join(Config.target.root
								Config.target.static,
								Config.target.scripts
								Config.filters.scripts.all)
					]

				target = Config.target.root

				debug 'sources', sources
				debug 'target', target
				debug "Starting"
				debug 'existing manifest', Manifest

				Manifest.empty()

				debug 'new manifest', Manifest

				return Gulp.src sources, base: Config.target.root
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('manifest')
					.pipe Plugins.clean()
					.pipe Plugins.fingerprinter().revision()
					.pipe Plugins.tap manifest.add
					.pipe logger.outgoing()
					.pipe Gulp.dest target
					.on 'error', debug
					.on 'finish', ->
						debug "Finished"
	]
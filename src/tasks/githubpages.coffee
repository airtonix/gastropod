
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
debug = require('debug')('gastropod/tasks/images')

{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.githubpages', [
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
			Gulp.task 'deploy:github-pages', (done)->
				logger = new Logger('deploy')
				source = path.join(Config.target.root,
									 Config.filters.all)

				debug 'source', source
				debug 'Starting'

				return Gulp.src source
					.pipe logger.incoming()
					.pipe Plugins.plumber ErrorHandler('deploy:github-pages')
					.pipe Plugins.gitPages Config.deploy
					.pipe logger.outgoing()
					.on 'error', (err)-> debug err
					.on 'finish', ()-> debug "Finished"
	]
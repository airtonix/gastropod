
#
# System
#
path = require 'path'

#
# Framework
{pongular} = require 'pongular'
debug = require('debug')('gastropod/jobs/watch')

#
# Exportable
pongular.module 'gastropod.jobs.watch', [
	'gastropod.config'
	'gastropod.vendor.gulp'
	'gastropod.core.logging'
	'gastropod.plugins'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		(Gulp, Plugins, Config)->
			config = Config

			Gulp.task 'watch', (done)->
				done() unless config?
				done() unless config.watch
			# 	source = path.join(config.source.root,
			# 					   config.filters.all)

			# 	debug('watching', source)
			# 	Gulp.watch source, ['compile']
	]
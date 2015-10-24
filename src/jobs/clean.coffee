#
# Framework
{pongular} = require 'pongular'
debug = require('debug')('gastropod/jobs/clean')

#
# Exportable
pongular.module 'gastropod.jobs.clean', [
	'gastropod.vendor.gulp'
	'gastropod.plugins'
	]

	.run [
		'GulpService'
		'PluginService'
		(Gulp, Plugins)->
			run = Plugins.runsequence

			Gulp.task 'clean', (done)->
				run([
					'clean:scripts'
					'clean:styles'
					'clean:images'
					'clean:fonts'
					'clean:pages'
				], done)
	]
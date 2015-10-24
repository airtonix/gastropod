#
# Framework
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.jobs', [
	'gastropod.vendor.gulp'
	'gastropod.jobs.server'
	'gastropod.jobs.watch'
	'gastropod.jobs.compile'
	]

	.run [
		'GulpService'
		(Gulp)->

			###*
			 * Main Entrypoint
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###
			Gulp.task 'default', ['compile', 'server', 'watch'], (done)->
				# $.runsequence , done
				done()
	]
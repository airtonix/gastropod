#
# Framework
debug = require('debug')('gastropod/jobs/compile')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.jobs.compile', [
	'gastropod.vendor.gulp'
	'gastropod.plugins'
	'gastropod.config'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		(Gulp, Plugins, Config)->

			run = Plugins.runsequence
			pipeline = Config.pipeline
			debug 'pipeline', pipeline

			Gulp.task 'styles', (done)->
				tasks = ['clean:styles' ].concat pipeline.styles
				tasks.push done
				debug 'running', tasks
				run.apply run, tasks

			Gulp.task 'scripts', (done)->
				tasks = ['clean:scripts' ].concat pipeline.scripts
				tasks.push done
				debug 'running', tasks
				run.apply run, tasks

			Gulp.task 'fonts', (done)->
				tasks = ['clean:fonts' ].concat pipeline.fonts
				tasks.push done
				debug 'running', tasks
				run.apply run, tasks

			Gulp.task 'images', (done)->
				tasks = ['clean:images' ].concat pipeline.images
				tasks.push done
				debug 'running', tasks
				run.apply run, tasks

			Gulp.task 'pages', (done)->
				tasks = ['clean:pages' ].concat pipeline.templates
				tasks.push done
				debug 'running', tasks
				run.apply run, tasks

			###*
			 * Compile
			 * @param  {Function} done [description]
			 * @return {[type]}        [description]
			###

			Gulp.task 'compile', (done)->
				run(['styles', 'scripts', 'fonts', 'images'],
					# ['collection', 'manifest'],
					'pages', done)
	]
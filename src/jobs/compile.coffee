#
# Framework
debug = require('debug')('gastropod/jobs/compile')
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'

#
# Exportable
run = Plugins.runsequence
pipeline = Config.pipeline
debug 'pipeline', pipeline

gulp.task 'styles', (done)->
	tasks = ['clean:styles' ].concat pipeline.styles
	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'scripts', (done)->
	tasks = ['clean:scripts' ].concat pipeline.scripts
	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'copy', (done)->
	tasks = ['clean:copies' ].concat pipeline.fonts
	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'images', (done)->
	tasks = ['clean:images' ].concat pipeline.images
	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'pages', (done)->
	tasks = ['clean:pages' ].concat pipeline.templates
	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'compile', (done)->
	run(['styles', 'scripts', 'copy', 'images'],
		'manifest',
		'pages',
		()->
			debug 'done'
			done()
	)
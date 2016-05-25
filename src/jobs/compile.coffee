#
# Framework
debug = require('debug')('gastropod/jobs/compile')
gulp = require 'gulp'

#
# Project
Config = require('../config')
Plugins = require '../plugins'

#
# Exportable
run = Plugins.runsequence
pipeline = Config.Store.pipeline

gulp.task 'styles', (done)->
	tasks = []

	if pipeline.styles?
		tasks.push 'clean:styles'
		tasks = tasks.concat pipeline.styles

	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'scripts', (done)->
	tasks = []

	if pipeline.scripts?
		tasks.push 'clean:scripts'
		tasks = tasks.concat pipeline.scripts

	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'copy', (done)->
	tasks = []

	if pipeline.copy?
		tasks.push 'clean:copies'
		tasks = tasks.concat pipeline.copy

	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'documentation', (done)->
	tasks = []

	if pipeline.docs?
		tasks.push 'clean:docs'
		tasks = tasks.concat pipeline.docs

	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'pages', (done)->
	tasks = []

	if pipeline.templates
		tasks.push 'clean:pages'
		tasks = tasks.concat pipeline.templates

	tasks.push done
	debug 'running', tasks
	run.apply run, tasks

gulp.task 'compile', (done)->
	run(['styles', 'scripts'],
		'copy',
		'manifest',
		'pages',
		'documentation',
		()->
			debug 'done'
			done()
	)

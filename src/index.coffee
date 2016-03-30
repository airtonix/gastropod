
#
# System
#
path = require 'path'

#
# Framework
_ = require 'lodash'
gulp = require 'gulp'
chalk = require 'chalk'
load = require 'require-all'
debug = require('debug')('gastropod')
merge = require 'deepmerge'
postmortem = require 'postmortem'
moduleFinder = require('module-finder')
Q = require 'bluebird'

#
# Project
ConfigStore = require('./config')
{Config} = require('./config')

#
# Gastropod Class
class Gastropod
	logging: require './core/logging'

	loadJobs: ->
		new Q (resolve, reject)->
			jobs = load({
				dirname: path.join(__dirname, 'jobs')
				filter: /(.+)\.[js|coffee|litcoffee]+$/
			})
			resolve(jobs)

	loadTasks: ->
		new Q (resolve, reject)->
			tasks = load({
				dirname: path.join(__dirname, 'tasks')
				filter: /(.+)\.[js|coffee|litcoffee]+$/
			})
			resolve(tasks)

	loadAddons: ->

		new Q (resolve, reject)=>
			query =
				local: true
				cwd: process.cwd()
				filter: {
					keywords: {$in: ['gastropod']}
				}

			debug 'searching for gastropod addons'
			addons = {}
			moduleFinder(query)
				.then (modules)=>
					debug 'found modules', modules.length
					modules.forEach (addon)=>
						name = addon.pkg.name
						dirname = path.dirname(addon.path)
						debug 'loading', "#{name}@#{dirname}"
						addons[name] = require(dirname)(gulp, @)
						debug "initialised:",  name
					resolve(addons)
				.catch (err)->
					reject(err)

	init: (options={})->
		ConfigStore.init(options)
		@Config = ConfigStore.build()
		@Plugins = require './plugins'
		@Logging = require './core/logging'
		@Utils = require './core/utils'
		@loadAddons()
			.then @loadJobs
			.then @loadTasks
			.finally ->
				debug 'gulp.tasks', Object.keys(gulp.tasks)

	run: (tasks)->
		if typeof tasks is 'string'
			tasks = [tasks, ]
		run = require('run-sequence').use(gulp)
		debug 'running tasks', tasks
		run.apply run, tasks

	list: (what)->
		switch what
			when 'addons'
				console.log Object.keys(@addons)

module.exports = Gastropod

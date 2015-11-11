
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

#
# Gastropod Class
class Gastropod

	loadJobs = ->
		new Q (resolve, reject)->
			jobs = load({
				dirname: path.join(__dirname, 'jobs')
				filter: /(.+)\.[js|coffee|litcoffee]+$/
			})
			resolve(jobs)


	loadTasks = ->
		new Q (resolve, reject)->
			tasks = load({
				dirname: path.join(__dirname, 'tasks')
				filter: /(.+)\.[js|coffee|litcoffee]+$/
			})
			resolve(tasks)

	loadAddons = ->

		new Q (resolve, reject)->
			query =
				local: true
				cwd: process.cwd()
				filter: {
					keywords: {$in: ['gastropod']}
				}

			debug 'searching for gastropod addons'
			addons = {}
			moduleFinder(query)
				.then (modules)->
					debug 'found modules', modules.length
					modules.forEach (addon)=>
						name = addon.pkg.name
						debug 'loading', name
						addon = require addon.path
						addons[name] = addon
						debug "initialised:",  name
					resolve(addons)
				.catch (err)->
					reject(err)

	init: (options={})->
		ConfigStore.init options

		loadAddons()
			.then loadJobs
			.then loadTasks


	run: (tasks)->
		if typeof tasks is 'string'
			tasks = [tasks, ]

		debug 'running tasks', tasks
		gulp.start tasks

	list: (what)->
		switch what
			when 'addons'
				console.log Object.keys(@addons)

module.exports = Gastropod
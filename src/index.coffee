
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

#
# Project
ConfigStore = require('./config')

#
# Gastropod Class
class Gastropod

	constructor: (options={})->
		ConfigStore.init options
		@loadAddons()

		jobs = load({
			dirname: path.join(__dirname, 'jobs')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		})
		tasks = load({
			dirname: path.join(__dirname, 'tasks')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		});

	loadAddons: ->
		query =
			local: true
			recursive: true
			cwd: process.cwd()
			filter: {
				keywords: {$in: ['gastropod-plugin']}
			}

		debug 'searching for gastropod addons'
		moduleFinder(query)
			.then (modules)->
				try
					modules.forEach (addon)->
						debug 'loading', addon.pkg.name
						addon = require addon.path
						cache[name] = addon
						debug "initialised [#{addonType}]:",  name

				catch err
					postmortem.prettyPrint err

	run: (tasks)->
		if typeof tasks is 'string'
			tasks = [tasks, ]

		debug 'running tasks', tasks
		gulp.start tasks

module.exports = Gastropod
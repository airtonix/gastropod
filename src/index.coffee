
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

#
# Project
ConfigStore = require('./config')

#
# Gastropod Class
class Gastropod

	constructor: (options={})->
		ConfigStore.init options

		jobs = load({
			dirname: path.join(__dirname, 'jobs')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		})
		tasks = load({
			dirname: path.join(__dirname, 'tasks')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		});

	# ###*
	#  * Find npm installed `gastropod-addon-*`
	# ###
	# loadAddons: ->
	# 	dependencies = _.extend {}, (@pkg.dependencies ? {}), (@pkg.devDependencies ? {})

	# 	debug 'searching for gastropod addons'

	# 	_.chain dependencies
	# 		.keys()
	# 		.filter (name)-> /^gastropod\-(.*)$/igm.test name
	# 		.each (name)=>
	# 			debug 'loading', name
	# 			try
	# 				addonPath = path.join process.cwd(), 'node_modules', name
	# 				addonPkgPath = path.join addonPath, 'package.json'

	# 				addonPkg = require addonPkgPath
	# 				addonType = addonPkg?.config?.type ? 'task'

	# 				cache = @addons[addonType]?={}

	# 				addon = require addonPath
	# 				cache[name] = addon
	# 				@initialiseModule(addon)
	# 				debug "initialised [#{addonType}]:",  name
	# 			catch err
	# 				postmortem.prettyPrint err

	# 		.value()
	# 	return

	run: (tasks)->
		if typeof tasks is 'string'
			tasks = [tasks, ]

		debug 'running tasks', tasks
		gulp.start tasks

module.exports = Gastropod
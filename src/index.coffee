
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
{pongular} = require 'pongular'

# load all the parts of the app as pongular modules
parts = load(dirname: __dirname, filter: /(.+)\.[js|coffee|litcoffee]+$/)

# create the root pongular module
app = pongular.module('gastropod', [
		'gastropod.vendor'
		'gastropod.config'
		'gastropod.core'
		'gastropod.plugins'
		'gastropod.tasks'
		'gastropod.jobs'
	])

###*
 * Gastropod Class
###
class Gastropod

	constructor: (@options={})->
		options = @options
		app.config [
			'ConfigStoreProvider'
			(Config)->
				Config.init options
		]
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

	serve: ()->
		app.run [
			'ConfigStore'
			'GastroServer'
			(Config, Server)->
				Server.init Config
				Server.start()
		]

		pongular.injector(['gastropod'])


	run: (tasks)->
		app.run [
			'GulpService'
			(Gulp)->
				if typeof tasks is 'string'
					tasks = [tasks, ]

				debug 'running tasks', tasks
				Gulp.start tasks

		]

		pongular.injector(['gastropod'])


module.exports = Gastropod
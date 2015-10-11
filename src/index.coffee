
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'


#
# Framework
#
_ = require 'lodash'
gulp = require 'gulp'
chalk = require 'chalk'
Logger = require './core/logging/logger'
load = require 'require-all'
nconf = require 'nconf'
debug = require('debug')('gastropod')
merge = require 'deepmerge'
postmortem = require 'postmortem'


###*
 * Gastropod Class
###
class Gastropod

	@masterConfig = require '../config/master'

	addons: {}

	constructor: (options={})->
		@pkg = require(path.join(process.cwd(), 'package.json'))

		# user memory as storage
		nconf.use 'memory'
		# TOP: cli arguments layered on top
		nconf.argv()
		# TOP - 1: gastropod__environment__variables
		nconf.env match: /^gastropod__(.*)/
		# TOP - 2: '~/.gastropod/{{project.name}}/config.json'
		# TOP - 3: '~/.gastropod/{{project.name}}/config.{{ env }}.json'
		# TOP - 4: './config.json'
		# TOP - 5: './config.development.json'
		# debug 'layering', projectConfigPath
		# nconf.file 'project.environment', "./config.#{process.env}.json"
		# nconf.file 'project',  './config.json'

		projectConfigPath = path.resolve options.config
		projectConfig = require projectConfigPath

		nconf.add 'project',
			type: 'literal'
			store: projectConfig

		nconf.add 'defaults',
			type: 'literal'
			store: Gastropod.masterConfig

		@config = nconf.get()
		debug 'nconf loaded'

		@plugins = require './core/plugins'
		@jobs = @register path.join __dirname, 'jobs'
		@tasks = @register path.join __dirname, 'tasks'
		@loadAddons()

	###*
	 * Register a gulp task
	 * @param  {String} globpath container directory
	 * @return {Object}          Map of tasks
	###
	register: (globpath)->
		debug 'registering gulp component', globpath
		load
			dirname: globpath
			filter: /(.+)\.[js|coffee|litcoffee]+$/
			resolve: @initialiseModule

	initialiseModule: (addon)=>
		addon(gulp, @plugins, @config)

	###*
	 * Find npm installed `gastropod-addon-*`
	###
	loadAddons: ->
		dependencies = _.extend {}, (@pkg.dependencies ? {}), (@pkg.devDependencies ? {})

		debug 'searching for gastropod addons'

		_.chain dependencies
			.keys()
			.filter (name)-> /^gastropod\-(.*)$/igm.test name
			.each (name)=>
				debug 'loading', name
				try
					addonPath = path.join process.cwd(), 'node_modules', name
					addonPkgPath = path.join addonPath, 'package.json'

					addonPkg = require addonPkgPath
					addonType = addonPkg?.config?.type ? 'task'

					cache = @addons[addonType]?={}

					addon = require addonPath
					cache[name] = addon
					@initialiseModule(addon)
					debug "initialised [#{addonType}]:",  name
				catch err
					postmortem.prettyPrint err

			.value()
		return

	list: (what)->
		if not what of @
			debug "#{what} not available."
			return

		debug JSON.stringify @[what], null, 4

	run: (tasks)->
		# gulp_src = gulp.src
		# gulp.src = ()=>
		# 	gulp_src.apply gulp, arguments
		# 		.pipe @plugins.plumber (error)=>
		# 			message = "Error (#{error.plugin}): #{error.message}"
		# 			@plugins.util.log @plugins.util.colors.red message
		# 			@emit 'end'
		gulp.on 'error', (err)->
			postmortem.prettyPrint err

		if typeof tasks is 'string'
			tasks = [tasks, ]
		debug 'running tasks', tasks
		gulp.start tasks

module.exports = Gastropod
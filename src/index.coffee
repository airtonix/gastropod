
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
deepmerge = require 'deepmerge'
###*
 * Gastropod Class
###
class Gastropod

	@defaults = require '../config/default'

	constructor: (options={})->
		pkg = require(__dirname, 'package.json')

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
		# nconf.add 'project.specified',
		# 	type: 'literal'
		# 	store: require projectConfigPath
		# nconf.file 'project.environment', "./config.#{process.env}.json"
		# nconf.file 'project',  './config.json'

		projectConfigPath = path.resolve options.config
		projectConfig = require projectConfigPath
		nconf.defaults _.merge {}, Gastropod.defaults, projectConfig

		debug 'nconf loaded all config layers'

		@gulp = gulp
		@config = nconf.get()
		@plugins = require './core/plugins'
		debug @config

		@jobs = @register path.join __dirname, 'jobs'
		@tasks = @register path.join __dirname, 'tasks'

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
			resolve: (task)=> task(@gulp, @plugins, @config)

	run: (tasks)->
		if typeof tasks is 'string'
			tasks = [tasks, ]
		debug 'running tasks', tasks
		@gulp.start(tasks)

module.exports = Gastropod
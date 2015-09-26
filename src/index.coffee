
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
debug = require('debug')('gremlinjs')


###*
 * Gremlin Class
###
class Gremlin

	constructor: (options={})->
		nconf.use 'memory'
		nconf.argv()
		nconf.env()
		nconf.file 'config.json'
		nconf.file "config.#{process.env}.json"
		nconf.defaults require '../config/default'

		debug 'nconf loaded all config layers'

		@gulp = gulp
		@config = nconf.get()
		@logger = new Logger('Gremlin')
		@plugins = require './core/plugins'

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

module.exports = Gremlin
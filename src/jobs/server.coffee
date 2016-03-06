
#
# System
path = require 'path'

#
# Framework
_ = require 'lodash'
postmortem = require 'postmortem'
debug = require('debug')('gastropod/jobs/server')
bodyParser = require 'body-parser'
quip = require 'quip'
morgan = require 'morgan'
errorhandler = require 'errorhandler'
merge = require 'deepmerge'
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'


defaults =
	server:
		baseDir: path.join process.cwd(), Config.target.root
		middleware: [
			morgan('dev')
			bodyParser.json()
			bodyParser.urlencoded extended:false
		]

###*
 * [description]
 * @return {[type]} [description]
 * @todo mount middleware on `instance.app.use`
 * @todo auto reload middleware with nodemon?
###
gulp.task 'server', (done)->
	console.log Config.plugins.server

	if Config.plugins.server

		serverConfig = _.defaultsDeep defaults, Config.plugins.server
		debug 'serverConfig', serverConfig
		try
			debug 'starting browsersync'
			Plugins.browsersync.init serverConfig, (err, instance) ->
				debug 'browsersync running'
				# access to :
				# - `instance.app` the Connect Server
				done()

		catch err
			postmortem.prettyPrint err
			done(err)

	else
		done()

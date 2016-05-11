
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
Q = require 'bluebird'

#
# Project
{Config} = require('../config')
Server = require '../core/server'
{Logger} = require '../core/logging'
logger = new Logger 'Server'
defaults =
	server:
		baseDir: path.join process.cwd(), Config.target.root
		middleware: [
			morgan('dev')
			bodyParser.json()
			bodyParser.urlencoded extended:false
		]

gulp.task 'server', (done)->
	return new Q (resolve, reject) =>
		if not Config.plugins.server
			resolve()

		try
			logger.msg 'Starting'
			serverConfig = _.defaultsDeep defaults, Config.plugins.server
			Server serverConfig
				.end ()->
					logger.msg "Running: \n\tFrom: thttp://0.0.0.0:#{@port} \n\tRoot: #{@root}"
					resolve()
		catch err
			reject(err)


#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
postmortem = require 'postmortem'
debug = require('debug')('gastropod/jobs/server')
bodyParser = require 'body-parser'
quip = require 'quip'
morgan = require 'morgan'
errorhandler = require 'errorhandler'
merge = require 'deepmerge'

module.exports = (gulp, $, config)->
	defaults =
		server:
			baseDir: path.join process.cwd(), config.target.root
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
		done() unless config.plugins.server

		serverConfig = _.defaultsDeep defaults, config.plugins.server

		debug 'serverConfig', serverConfig
		try
			debug 'starting browsersync'
			$.browsersync.init serverConfig, (err, instance) ->
				debug 'browsersync running'
				# access to :
				# - `instance.app` the Connect Server
				done()

		catch err
			postmortem.prettyPrint err
			done(err)



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


module.exports = (gulp, $, config)->

	###*
	 * [description]
	 * @return {[type]} [description]
	 * @todo mount middleware on `instance.app.use`
	 * @todo auto reload middleware with nodemon?
	###
	gulp.task 'server', (done)->
		done() unless config.plugins.server

		try
			debug 'starting browsersync'
			$.browsersync.init config.plugins.server, (err, instance) ->
				debug 'browsersync running'
				# access to :
				# - `instance.app` the Connect Server
				done()

		catch err
			postmortem.prettyPrint err
			done(err)


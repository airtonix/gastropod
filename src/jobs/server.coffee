
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'


module.exports = (gulp, $, config)->

	###*
	 * [description]
	 * @return {[type]} [description]
	###
	gulp.task 'server', (done)->
		$.browsersync.init config.plugins.server, done

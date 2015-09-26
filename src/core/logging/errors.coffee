#
# System
#

#
# Framework
#
chalk = require 'chalk'
util = require 'gulp-util'

###*
 * ErrorHandler
###
ErrorHandler = (name)->
	name = util.colors.red "[#{name}]"
	(err)->
		util.log name, err
		@emit 'end'


module.exports = ErrorHandler
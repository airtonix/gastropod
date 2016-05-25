#
# Framework
gulp = require 'gulp'
debug = require('debug')('gastropod/jobs/default')

#
# project
Plugins = require '../plugins'

###*
 * Main Entrypoint
 * @param  {Function} done [description]
 * @return {[type]}        [description]
###
gulp.task 'default', (done)->
	Plugins.runsequence 'compile', ['server', 'watch'], done

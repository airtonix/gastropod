#
# Framework
gulp = require 'gulp'
debug = require('debug')('gastropod/jobs/default')

#
# project
{Config} = require('../config')
Plugins = require '../plugins'

###*
 * Main Entrypoint
 * @param  {Function} done [description]
 * @return {[type]}        [description]
###
gulp.task 'default', (done)->
	Plugins.runsequence 'clean', 'compile', ['server', 'watch'], done

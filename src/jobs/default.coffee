
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
	 * Main Entrypoint
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'default', (done)->
		$.runsequence 'compile', 'server', 'watch', done

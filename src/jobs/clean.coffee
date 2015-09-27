###*
 * CleanUp
###

#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'



module.exports = (gulp, $, config)->

	gulp.task 'clean', (done)->
		$.runsequence 'clean:scripts', 'clean:styles', 'clean:images', 'clean:fonts', 'clean:pages', done

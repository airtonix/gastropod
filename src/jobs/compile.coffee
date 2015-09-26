
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'


module.exports = (gulp, $, config)->

	gulp.task 'styles',  ['clean:styles', 'scss']
	gulp.task 'scripts',  ['clean:scripts', 'browserify']
	gulp.task 'pages',  ['clean:pages', 'swig']

	###*
	 * Compile
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'compile', (done)->
		$.runsequence 'clean', ['styles', 'scripts', 'fonts'], 'manifest', 'pages', done

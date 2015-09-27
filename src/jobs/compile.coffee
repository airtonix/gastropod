
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'


module.exports = (gulp, $, config)->

	gulp.task 'styles',  ['clean:styles' ].concat config.pipeline.styles
	gulp.task 'scripts',  ['clean:scripts' ].concat config.pipeline.scripts
	gulp.task 'pages',  ['clean:pages' ].concat config.pipeline.templates

	###*
	 * Compile	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'compile', (done)->
		$.runsequence 'clean', ['styles', 'scripts', 'fonts'], 'manifest', 'pages', done

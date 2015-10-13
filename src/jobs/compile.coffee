
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
async = require 'async-chainable'


module.exports = (gulp, $, config)->

	gulp.task 'styles', (done)->
		tasks = ['clean:styles' ].concat config.pipeline.styles
		tasks.push done
		$.runsequence.apply $.runsequence, tasks

	gulp.task 'scripts', (done)->
		tasks = ['clean:scripts' ].concat config.pipeline.scripts
		tasks.push done
		$.runsequence.apply $.runsequence, tasks

	gulp.task 'pages', (done)->
		tasks = ['clean:pages' ].concat config.pipeline.templates
		tasks.push done
		$.runsequence.apply $.runsequence, tasks

	gulp.task 'fonts', (done)->
		tasks = ['clean:fonts' ].concat config.pipeline.fonts
		tasks.push done
		$.runsequence.apply $.runsequence, tasks

	gulp.task 'images', (done)->
		tasks = ['clean:images' ].concat config.pipeline.images
		tasks.push done
		$.runsequence.apply $.runsequence, tasks

	###*
	 * Compile
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'compile', (done)->
		$.runsequence(
			['styles', 'scripts', 'fonts', 'images'],
			['collection', 'manifest'],
			'pages', done)

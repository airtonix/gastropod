
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

#
# Projects
#
ErrorHandler = require '../core/logging/errors'
Logger = require '../core/logging/logger'
debug = require('debug')('gastropod/tasks/images')


module.exports = (gulp, $, config)->

	###*
	 * Images
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'images', ['clean:images'], (done)->
		logger = new Logger('images')
		source = path.join(config.source.root,
							 config.source.images,
							 config.filters.images)

		target = path.join(config.target.root,
						   config.target.images)

		debug 'source', source
		debug 'target', target

		gulp.src source, base: config.source.images
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('images')
			.pipe $.imagemin()
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'error', (err)-> debug err


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
debug = require('debug')('gremlinjs/tasks/styles')


module.exports = (gulp, $, config)->

	logger = new Logger('styles')
	###*
	 * Style Sheets
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'scss', (done)->

		source = path.join(config.source.root,
							 config.source.styles,
							 config.filters.styles)

		target = path.join(config.target.root,
						   config.target.styles)

		debug 'source', source
		debug 'target', target

		gulp.src source
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('Styles')
			.pipe $.sass(config.plugins.sass)
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'error', (err)-> debug err

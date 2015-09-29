
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
debug = require('debug')('gastropod/tasks/styles')


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
						   config.target.static,
						   config.target.styles)

		debug 'source', source
		debug 'target', target
		debug "Starting"

		return gulp.src source
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('Styles')
			.pipe $.sass(config.plugins.sass)
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.pipe logger.outgoing()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished"

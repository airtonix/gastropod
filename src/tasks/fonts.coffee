
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
debug = require('debug')('gastropod/tasks/fonts')


module.exports = (gulp, $, config)->

	###*
	 * Fonts
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'fonts', (done)->
		logger = new Logger('fonts')
		sources = [
			path.join(process.cwd(),
					  config.source.root,
					  config.source.fonts.internal,
					  config.filters.fonts)

			path.join(process.cwd(),
					  config.source.fonts.vendor,
					  config.filters.fonts)
		]
		target = path.join(config.target.root,
						   config.target.fonts)

		debug 'sources', sources
		debug 'target', target
		debug "Starting"

		return gulp.src sources
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('fonts')
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished"


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
debug = require('debug')('gastropod/tasks/scripts:browserify')


module.exports = (gulp, $, config)->

	###*
	 * Scripts
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'browserify', (done)->
		logger = new Logger('scripts:browserify')

		source = path.join(config.source.root,
						   config.source.scripts,
						   config.filters.scripts.modules)

		target = path.join(config.target.root,
						   config.target.scripts)

		debug "Starting"
		debug " > source", source
		debug " > target", target

		return gulp.src source
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('scripts:browserify')
			.pipe $.through.obj (file, env, next)->
				debug 'processing %s', file
				$.browserify(file.path, config.plugins.js.browserify)
					.transform $.nghtml2js module: 'templates'
					.bundle (err, results)->
						if err
							file.contents = null
							next err, file
						else
							file.contents = results
							next(null, file)

			.pipe $.rename
				extname: '.js'
			.pipe logger.info '<%= file.relative %> [<%= file.size %>]'
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished"

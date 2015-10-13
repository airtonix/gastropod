
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
						   config.target.static,
						   config.target.scripts)

		browserifyConfig = config.plugins.js.browserify
		transforms = browserifyConfig.transforms

		debug "Starting"
		debug " > source", source
		debug " > target", target

		return gulp.src source
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('scripts:browserify')
			.pipe $.through.obj (file, env, next)->

				browserify = $.browserify file.path, browserifyConfig

				for plugin, options in transforms
					if plugin of $
						transform = $[plugin]
						browserify.transform transform.apply options

				browserify.bundle (err, results)->
					debug 'processed %s', file.relative
					if err
						file.contents = null
						next err, file
					else
						file.contents = results
						next(null, file)

			.pipe $.rename
				extname: '.js'
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.pipe logger.outgoing()
			.on 'error', (err)-> debug err
			.on 'finish', ()-> debug "Finished"

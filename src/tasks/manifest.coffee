
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

#
# Project
#
ErrorHandler = require '../core/logging/errors'
manifest = require '../core/assets/manifest'
Logger = require '../core/logging/logger'
debug = require('debug')('gastropod/tasks/manifest')


module.exports = (gulp, $, config)->

	###*
	 * Generate Manifest
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'manifest', (done)->
		logger = new Logger('manifest')

		# set the root for the manifest
		manifest.option 'root', path.join config.target.root, config.target.static

		sources = [
				path.join(config.target.root
						config.target.static,
						config.target.images
						config.filters.images)

				path.join(config.target.root
						config.target.static,
						config.target.fonts
						config.filters.fonts)

				path.join(config.target.root
						config.target.static,
						config.target.styles
						config.filters.styles)

				path.join(config.target.root
						config.target.static,
						config.target.scripts
						config.filters.scripts.all)
			]

		target = config.target.root

		debug 'sources', sources
		debug 'target', target
		debug "Starting"

		return gulp.src sources, base: config.target.root
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('manifest')
			.pipe $.clean()
			.pipe $.fingerprinter().revision()
			.pipe $.tap manifest.add
			.pipe gulp.dest target
			.pipe logger.outgoing()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished"

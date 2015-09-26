
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
debug = require('debug')('gremlinjs/tasks/manifest')


module.exports = (gulp, $, config)->

	###*
	 * Generate Manifest
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'manifest', (done)->

		sources = [
				path.join(config.target.root
						config.target.images
						config.filters.images)

				path.join(config.target.root
						config.target.fonts
						config.filters.fonts)

				path.join(config.target.root
						config.target.styles
						config.filters.styles)

				path.join(config.target.root
						config.target.scripts
						config.filters.scripts.all)
			]
		target = config.target.root

		debug 'sources', sources
		debug 'target', target

		gulp.src sources, base: config.target.root
			.pipe $.plumber ErrorHandler('manifest')
			.pipe $.clean()
			.pipe $.fingerprinter().revision()
			.pipe $.tap manifest.build
			.pipe gulp.dest target
			.on 'error', (err)-> debug err

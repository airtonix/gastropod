
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
debug = require('debug')('gremlinjs/tasks/clean')


module.exports = (gulp, $, config)->

	gulp.task 'clean:scripts', (done)->
		logger = new Logger('clean:scripts')
		source = path.join(config.target.root,
							 config.target.scripts,
							 config.filters.scripts.all)

		debug 'source', source

		gulp.src source, read: false
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('clean:scripts')
			.pipe $.clean()
			.on 'error', (err)-> debug err


	gulp.task 'clean:styles', (done)->
		logger = new Logger('clean:styles')
		source = path.join(config.target.root,
							 config.target.styles,
							 config.filters.styles)

		debug 'source', source

		gulp.src source, read: false
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('clean:styles')
			.pipe $.clean()
			.on 'error', (err)-> debug err


	gulp.task 'clean:images', (done)->
		logger = new Logger('clean:images')
		source = path.join(config.target.root,
							 config.target.images,
							 config.filters.images)

		debug 'source', source

		gulp.src source, read: false
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('clean:images')
			.pipe $.clean()
			.on 'error', (err)-> debug err


	gulp.task 'clean:fonts', (done)->
		logger = new Logger('clean:fonts')
		source = path.join(config.target.root,
							 config.target.fonts,
							 config.filters.fonts)

		debug 'source', source

		gulp.src source, read: false
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('clean:fonts')
			.pipe $.clean()
			.on 'error', (err)-> debug err


	gulp.task 'clean:pages', (done)->
		logger = new Logger('clean:pages')
		source = path.join(config.target.root,
							 config.target.pages,
							 config.filters.patterns)

		debug 'source', source

		gulp.src source, read: false
			.pipe logger.info '<%= file.relative %>'
			.pipe $.plumber ErrorHandler('clean:pages')
			.pipe $.clean()
			.on 'error', (err)-> debug err

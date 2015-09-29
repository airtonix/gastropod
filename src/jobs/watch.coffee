
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
debug = require('debug')('gastropod/jobs/watch')


module.exports = (gulp, $, config)->

	gulp.task 'watch', (done)->
		done() unless config.watch

		source = path.join(config.source.root,
						   config.filters.all)

		debug('watching', source)
		gulp
			.watch source, ['compile']
			.on 'change', (file)->
				debug 'changed', file

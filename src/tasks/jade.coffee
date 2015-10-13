
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
Logger = require '../core/logging/logger'
debug = require('debug')('gastropod/tasks/pages:jade')
ContextFactory = require '../core/templates/context'
Manifest = require '../core/assets/manifest'
jade = require 'jade'


module.exports = (gulp, $, config)->
	###*
	 * Templates
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'jade', (done)->
		logger = new Logger('pages:jade')
		source = path.join(config.source.root,
						   config.source.pages,
						   config.filters.patterns)

		patterns = path.join(process.cwd(),
							 config.source.root,
						     config.source.patterns)

		globals = path.join(process.cwd(),
							config.source.root,
						    config.source.data)

		target = path.join config.target.root, '/'

		Context = new ContextFactory()
		Context.add require globals
		Context.add manifest: Manifest.db

		debug 'source', source
		debug 'target', target

		debug "Starting"

		return gulp.src source
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('pages:jade')
			.pipe $.frontMatter
				property: 'meta'
				remove: true
			.pipe $.data Context.export
			.pipe $.jade basedir: patterns
			.pipe gulp.dest target
			.pipe $.browsersync.stream()
			.pipe logger.outgoing()
			.on 'error', (err)-> debug err
			.on 'finish', ()-> debug "Finished"

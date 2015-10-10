
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
debug = require('debug')('gastropod/tasks/images')


module.exports = (gulp, $, config)->

	###*
	 * Images
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'deploy:github-pages', (done)->
		logger = new Logger('deploy')
		source = path.join(config.target.root,
							 config.filters.all)

		debug 'source', source
		debug 'Starting'

		return gulp.src source
			.pipe logger.incoming()
			.pipe $.plumber ErrorHandler('deploy:github-pages')
			.pipe $.gitPages config.deploy
			.pipe logger.outgoing()
			.on 'error', (err)-> debug err
			.on 'end', ()-> debug "Finished"


#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

module.exports = (gulp, $, config)->

	###*
	 * [description]
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	gulp.task 'watch', (done)->
		gulp.watch [
			path.join(config.source.root,
						config.filters.all)
		], ['compile']

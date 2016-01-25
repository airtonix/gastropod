#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/core/assets/hasher')

###*
 * https://www.npmjs.com/package/gulp-rev-all#transformfilename
 * @param  {[type]} file [description]
 * @param  {[type]} hash [description]
 * @return {[type]}      [description]
###
module.exports = (file, hash)->
	ext = path.extname(file.path)
	basename = path.basename(file.path, ext)
	debug('renaming', basename)

	output = hash.substr(0, 5) + '.'  + basename + ext
	return output

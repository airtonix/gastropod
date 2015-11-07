#
# System
#
path = require 'path'

###*
 * [hasher description]
 * @param  {[type]} file [description]
 * @param  {[type]} hash [description]
 * @return {[type]}      [description]
###
module.exports = (file, hash)->
	ext = path.extname(file.path)
	output = hash.substr(0, 5) + '.'  + path.basename(file.path, ext) + ext
	return output

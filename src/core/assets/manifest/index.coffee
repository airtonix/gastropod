#
# System
#
_ = require 'lodash'
path = require 'path'


###*
 * Manifester Class
###
class Manifester

	db: {}

	build: (file, tap)=>
		here = path.join(path.resolve(file.path, __dirname), options.target.root)
		original = file.revPathOriginal.replace here+'/', ''
		hashed = file.path.replace here+'/', ''
		@db[original] = hashed


module.exports = new Manifester()
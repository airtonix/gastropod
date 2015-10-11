#
# System
#
_ = require 'lodash'
path = require 'path'
debug = require('debug')('gastropod/core/assets/manifest')

###*
 * Manifester Class
###
class Manifester

	db: {}
	options: {}

	option: (key, value)->
		debug 'setting option', key, value
		@options[key] = value

	empty: ->
		debug 'emptying manifest'
		@db = {}

	add: (file, tap)=>
		filePathSplit = file.path.split(@options.root+'/')
		current = filePathSplit.length and filePathSplit[1] ? file.path
		original = current

		if 'revPathOriginal' of file
			originalSplit = file.revPathOriginal.split(@options.root+'/')
			original = originalSplit.length and originalSplit[1] or file.revPathOriginal

		debug 'manifest.add', original, ' = ', current

		@db[original] = current


module.exports = new Manifester()
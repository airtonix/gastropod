#
# System
path = require 'path'


#
# Framework
_ = require 'lodash'
debug = require('debug')('gastropod/core/assets/manifest')
unixify = require 'unixify'

#
# Project
{Config} = require '../../config'


class ManifestService

	db: {}
	options: {}

	option: (key, value)->
		debug 'setting option', key, value
		@options[key] = value

	pattern: ->
		# let someone else replace our slashes.
		root = unixify(@options.root).replace('/', '\/')

		# 1. from the start
		# 2. optionally zero or more characters, until
		# 3. the string @options.root (with slashes escaped)
		# 4. optionally with trailing slashes
		# 5. and then everything after that (the bit we care about)
		#
		# 1   2  3         4           5
		# ^  .* (#{root}) (\\/|\\\\)? (.*)
		return new RegExp("^.*(#{root})(\\/|\\\\)?(.*)")

	empty: ->
		debug 'emptying manifest'
		@db = {}

	add: (file, tap) =>
		filePath = unixify(file.path)
		pattern = @pattern()

		current = filePath.replace(pattern, '$3')
		original = current

		if 'revPathOriginal' of file
			original = unixify(file.revPathOriginal).replace(@pattern(), '$3')

		debug 'manifest.add', original, ' = ', current

		@db[original] = current
		return

#
# Exportable
module.exports = new ManifestService()

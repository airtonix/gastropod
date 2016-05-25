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
Config = require '../../config'


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

	format: (filepath) ->
		pattern = @pattern()
		return unixify(filepath).replace(pattern, '$3')

	empty: ->
		debug 'emptying manifest'
		@db = {}

	export: () ->
		debug 'exporting manifest'
		return JSON.stringify @db, null, 2

	add: (logical, actual) =>
		actualPath = @format(actual)
		logicalPath = @format(if logical then logical else actual)
		debug 'manifest.add', logicalPath, ' = ', actualPath
		@db[logicalPath] = actualPath
		return

#
# Exportable
module.exports = new ManifestService()

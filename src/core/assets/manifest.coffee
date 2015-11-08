#
# System
path = require 'path'


#
# Framework
_ = require 'lodash'
debug = require('debug')('gastropod/core/assets/manifest')

#
# Project
{Config} = require '../../config'


class ManifestService

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


#
# Exportable
module.exports = new ManifestService()

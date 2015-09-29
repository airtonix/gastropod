#
# System
#
path = require 'path'
fs = require 'fs'

#
# Project
#
debug = require('debug')('gastropod/core/swig/configurator')


class SwigConfigFactory

	constructor: (@options)->

	setup: (swig)=>
		swig.setDefaults
			loader: swig.loaders.fs @options.root
			locals: @options.globals
			cache: false

		debug 'swig configured.'

		tags = path.resolve path.join __dirname, 'tags'
		filters = path.resolve path.join __dirname, 'filters'

		try
			debug 'loading filters', filters
			for item in fs.readdirSync(filters)
				name = path.basename item, path.extname item
				filter = require(path.join filters, item)
				debug 'registering filter', name
				swig.setFilter name, filter
		catch err
			debug err

		try
			debug 'loading tags', tags
			for item in fs.readdirSync(tags)
				name = path.basename item, path.extname item
				tag = require(path.join tags, item)
				debug 'registering tag', name
				swig.setTag name, tag.parse, tag.compile, tag.ends, tag.block

				if tag?.ext and tag.ext?.name and tag.ext?.obj
					{name, obj} = tag?.ext
					debug 'registering tag.extension', name
					swig.setExtension name, obj
		catch err
			debug err

module.exports = SwigConfigFactory
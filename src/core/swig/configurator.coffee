#
# System
#
path = require 'path'

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

		tags = path.resolve path.join __dirname, 'tags'
		filters = path.resolve path.join __dirname, 'filters'

		for item in fs.readdirSync(filters)
			name = path.basename item, path.extname item
			filter = require(path.join filters, item)
			debug 'registering filter', name
			swig.setFilter name, filter

		for item in fs.readdirSync(tags)
			name = path.basename item, path.extname item
			tag = require(path.join tags, item)

			debug 'registering tag', name
			swig.setTag name, tag.parse, tag.compile, tag.ends, tag.block

			if tag?.ext and tag.ext?.name and tag.ext?.obj
				{name, obj} = tag?.ext
				debug 'registering tag.extension', name
				swig.setExtension name, obj


module.exports = SwigConfigFactory
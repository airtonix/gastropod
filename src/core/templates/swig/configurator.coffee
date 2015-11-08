#
# System
path = require 'path'
fs = require 'fs'

#
# Framework
debug = require('debug')('gastropod/core/swig/configurator')
load = require 'require-all'


class SwigService

	options: null
	tags: []
	filters: []

	configure: (@options)->
		debug 'configured', @options
		@filters = load({
			dirname: path.join(__dirname, 'filters')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		})
		@tags = load({
			dirname: path.join(__dirname, 'tags')
			filter: /(.+)\.[js|coffee|litcoffee]+$/
		})

	setup: (swig)=>
		debug 'setting up swig instance'
		swig.setDefaults
			loader: swig.loaders.fs @options.sources
			cache: false

		for name, filter of @filters
			debug 'registering filter', name
			swig.setFilter name, filter

		for name, tag of @tags
			debug 'registering tag', name
			swig.setTag name, tag.parse, tag.compile, tag.ends, tag.block

			if 'ext' of tag and tag.ext?.name and tag.ext?.obj
				{name, obj} = tag.ext
				debug 'registering tag.extension', name
				swig.setExtension name, obj

		debug 'swig configured.'

	addFilter: (name, fn)->
		debug 'adding filter', name
		@filters.push name: name, module: fn

	addTag: (name, fn)->
		debug 'adding tag', name
		@tags.push name: name, module: fn


module.exports = new SwigService



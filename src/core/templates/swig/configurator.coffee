#
# System
path = require 'path'
fs = require 'fs'

#
# Framework
debug = require('debug')('gastropod/core/swig/configurator')
{pongular} = require 'pongular'

class SwigService

	options: null
	tags: []
	filters: []

	configure: (@options)->
		debug 'configured', @options

	setup: (swig)=>
		swig.setDefaults
			loader: swig.loaders.fs @options.sources
			cache: false


		for filter in @filters
			debug 'registering filter', filter.name
			swig.setFilter filter.name, filter.module

		for tag in @tags
			debug 'registering tag', tag.name
			swig.setTag tag.name, tag.module.parse, tag.module.compile, tag.module.ends, tag.module.block

			if 'ext' of tag.module and tag.module.ext?.name and tag.module.ext?.obj
				{name, obj} = tag.module.ext
				debug 'registering tag.extension', name
				swig.setExtension name, obj

		debug 'swig configured.'

	addFilter: (name, fn)->
		debug 'adding filter', name
		@filters.push name: name, module: fn

	addTag: (name, fn)->
		debug 'adding tag', name
		@tags.push name: name, module: fn


SwigService = new SwigService


pongular.module 'gastropod.core.templates.swig.configurator', []

	.provider 'SwigConfig', [
		()->
			configure: SwigService.configure
			$get: [ ()-> SwigService ]

	]


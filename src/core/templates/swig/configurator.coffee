#
# System
path = require 'path'
fs = require 'fs'

#
# Framework
debug = require('debug')('gastropod/core/swig/configurator')
{pongular} = require 'pongular'


pongular.module 'gastropod.core.templates.swig.configurator', []

	.provider 'SwigConfig', [
		()->

			Options = null
			Tags = []
			Filters = []

			configure = (options)->
				Options = options

			setup = (swig)=>
				swig.setDefaults
					loader: Loaders.Fallback Options.sources
					cache: false

				debug 'swig configured.'

				for filter in Filters
					debug 'registering filter', filter.name
					swig.setFilter filter.name, filter.module

				for tag in Tags
					debug 'registering tag', tag.name
					swig.setTag tag.name, tag.module.parse, tag.module.compile, tag.module.ends, tag.module.block

					if 'ext' of tag.module and tag.module.ext?.name and tag.module.ext?.obj
						{name, obj} = tag.module.ext
						debug 'registering tag.extension', name
						swig.setExtension name, obj

			addFilter = (name, fn)->
				Filters.push name: name, module: fn

			addTag = (name, fn)->
				Tags.push name: name, module: fn

			configure: configure
			$get: [
				()->
					configure: configure
					addTag: addTag
					addFilter: addFilter
					setup: setup
			]
	]


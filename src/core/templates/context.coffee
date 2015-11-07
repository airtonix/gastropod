#
# System
path = require 'path'

#
# Framework
_ = require 'lodash'
debug = require('debug')('gastropod/core/templates/context')
postmortem = require 'postmortem'
deepmerge = require 'deepmerge'
requireUncached = require 'require-uncached'
Zeninjector = require 'zeninjector'
async = require 'async-chainable'
#
# Project
{Config} = require('../../config')
Templates = require './index'
Manifest = require '../assets/manifest'
PackageJson = require path.join(process.cwd(), 'package.json')
{CollectFiles} = require '../utils/files'

#
# Constants
NOOP = ->
PROJECT_GLOBAL_DATAROOT = path.join(process.cwd(),
				 				    Config.source.root,
				 				    Config.source.data)
CONTEXT_BUILTINS =
	Pkg: ()-> PackageJson
	Manifest: ()-> Manifest
	Templates: ()-> Templates

#
# Exportable
class Context
	container = null

	Store: {}

	add: (key, data)=>
		obj = {}
		obj[key] = data
		debug 'adding', obj
		@Store = deepmerge @Store, obj

	empty: ->
		@Store = {}

	getPath: (file)->
		directory = path.dirname file.path
		fileext = path.extname(file.path)
		filename = path.basename(file.path, fileext)
		datapath = path.join directory, filename
		debug 'datapath', datapath
		return datapath

	export: => (file, done)->
		data = _.clone(@Store)
		data.Meta = file.meta
		debug 'exporting data for file', Object.keys(data).length
		podule = @loadFile(file)
		# page = podule()
		page = project.invoke podule
		debug 'page', page
		done(null, {})

	###*
	 * Export Page Context
	 * @param  {[type]}   file [description]
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	loadFile: (file, done)->
		try
			fileDataPath = @getPath(file)
			return requireUncached fileDataPath

		catch err
			if not err.code is 'MODULE_NOT_FOUND'
				postmortem.prettyPrint err
			else
				throw err

	###*
	 * Prepare IOC Injection with builtins and project
	 * globals.
	 * @return {PongularModule} A pongular module
	###
	prepare: ->
		debug 'preparing ioc'
		container = new Zeninjector()
		AddToContext = @add
		try
			async()

				.then 'Globals', (next)->
					CollectFiles(PROJECT_GLOBAL_DATAROOT, Config.filters.data, {})
						.then (files)->
							output = {}
							for file in files
								podulePath = path.join PROJECT_GLOBAL_DATAROOT, file
								fileExt = path.extname(file)
								poduleName = path.basename(file, fileExt)
								poduleFactory = requireUncached podulePath
								output[poduleName] = poduleFactory
							next null, output

				.forEach CONTEXT_BUILTINS, (next, fn, key)->
					debug 'ioc.register.builtin', key
					# make it available as an injectable
					container.register key, fn
					next()

				.await()

				.forEach 'Globals', (next, fn, key)->
					debug 'ioc.register.globals', key
					# make it available as an injectable
					container.register key, fn
					next()

				.await()

				.forEach CONTEXT_BUILTINS, (next, fn, key)->
					debug 'ioc.resolving.builtin', key
					# add builtin to context
					container.inject([key, fn])
						.then (data)->
							AddToContext key, data
							next()

				.forEach  'Globals', (next, fn, key)->
					debug 'ioc.resolving.globals', key
					# add builtin to context
					container.inject([key, fn])
						.then (data)->
							AddToContext key, data
							next()

				.end (err)->
					debug 'done'
		catch err
			debug err

module.exports = new Context

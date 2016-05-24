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
				 				    Config.Store.source.root,
				 				    Config.Store.source.data)

# @TODO add Context Variable `Site` as a Builtin in `core/templates/context`
CONTEXT_BUILTINS =
	Pkg: ()-> PackageJson
	Manifest: ()-> Manifest.db
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

	export: (file, done)=>
		debug 'loading data for ', file.path
		podule = @loadFile(file)
		data = deepmerge _.clone(@Store), Config.Store.context
		data.Meta = file.meta

		if not podule
			data.Page = {}
			done null, data
		else
			container.inject(podule).then (page)=>
				debug 'exporting page'
				data.Page = page
				done null, data
	###*
	 * Export Page Context
	 * @param  {[type]}   file [description]
	 * @param  {Function} done [description]
	 * @return {[type]}        [description]
	###
	loadFile: (file)->
		try
			fileDataPath = @getPath(file)
			return requireUncached fileDataPath

		catch err
			if not err.code is 'MODULE_NOT_FOUND'
				postmortem.prettyPrint err

	###*
	 * Prepare IOC Injection with builtins and project
	 * globals.
	 * @return {PongularModule} A pongular module
	###
	prepare: ->
		debug 'preparing ioc'
		container = new Zeninjector()
		AddToContext = @add
		Store = @Store

		try
			async()

				.then 'Globals', (next)->
					CollectFiles(PROJECT_GLOBAL_DATAROOT, Config.Store.filters.data, {})
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

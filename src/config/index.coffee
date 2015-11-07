#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/config')
nconf = require 'nconf'
_ = require 'lodash'

#
# Constants
DefaultConfig = require './defaults'
PackageJson = require(path.join(process.cwd(), 'package.json'))

Config = {}

class ConfigStore

	constructor: ()->
		nconf.use 'memory'
		nconf.argv()
		nconf.env match: /^gastropod__(.*)/

	add: (key, value)->
		debug 'adding', key
		nconf.add key, type: 'literal', store: value

	build: ->
		store = nconf.get()
		debug 'exporting', store
		return store

	init: (options)->
		projectConfigPath = path.resolve(options.config)
		value = require projectConfigPath
		try
			debug 'adding environment: ', projectConfigPath
			@add 'project', value
		catch err
			debug 'missing ', projectConfigPath

		@add 'defaults', DefaultConfig

		module.exports.Config = Config = @build()

module.exports = new ConfigStore()
module.exports.Config = Config
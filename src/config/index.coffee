#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/config')
nconf = require 'nconf'
Q = require 'bluebird'
_ = require 'lodash'

#
# Constants
DefaultConfig = require './defaults'
PackageJson = require(path.join(process.cwd(), 'package.json'))

nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/

module.exports.Store = {}

module.exports = (options = {}) ->
	nconf.add 'config', type: 'literal', store: DefaultConfig

	if options and options.config
		projectConfigPath = path.resolve(options.config)
		try
			value = require projectConfigPath
			debug 'adding environment: ', projectConfigPath
			nconf.add 'config', type: 'literal', store: value

		catch err
			debug 'missing ', projectConfigPath

	module.exports.Store = nconf.get()
	return module.exports.Store

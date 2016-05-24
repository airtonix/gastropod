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

Store = {}

add = (data) =>
	nconf.add 'config', type: 'literal', store: data

compile = (options={}) =>

	if options.config
		projectConfigPath = path.resolve(options.config)
		try
			debug 'adding environment: ', projectConfigPath
			add(require(projectConfigPath))

		catch err
			debug 'missing ', projectConfigPath

		module.exports.Store = Store = nconf.get()
		return Store



nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/

add DefaultConfig

module.exports = compile
module.exports.add = add
module.exports.Store = Store



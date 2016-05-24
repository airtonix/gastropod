#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/config')
nconf = require 'nconf'

#
# Constants
PackageJson = require(path.join(process.cwd(), 'package.json'))

nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/
nconf.add 'defaults', type: 'literal', store: require './defaults'
debug 'added defaults: ', nconf.get()


module.exports.Store = Store = {}

module.exports = (options={}) ->

	if options.config

		projectConfigPath = path.resolve(options.config)

		try
			layer = require(projectConfigPath)
			# nconf.add 'config', type: 'literal', store: layer
			nconf.add 'config', type: 'literal', store: layer
			debug 'added environment: ', projectConfigPath, nconf.get()

		catch err
			debug 'missing ', projectConfigPath

	Store = nconf.get()
	module.exports.Store = Store
	return Store




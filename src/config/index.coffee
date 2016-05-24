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
defaults = require './defaults'

nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/


module.exports.Store = Store = {}
module.exports = (options={}) ->

	if options.config
		projectConfigPath = path.resolve(options.config)

		try
			layer = require(projectConfigPath)
			nconf.overrides store: layer
			debug 'added environment: ', projectConfigPath, nconf.get()

		catch err
			debug 'missing ', projectConfigPath

	nconf.defaults store: defaults
	module.exports.Store = Store = nconf.get()
	return Store




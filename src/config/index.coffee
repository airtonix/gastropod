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
Defaults = require './defaults'

nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/


module.exports.Store = Store = {}
module.exports = (options={}) ->

	if options.config
		try
			projectConfigPath = path.resolve(options.config)
			layer = require(projectConfigPath)
			nconf.overrides store: layer
			debug 'added environment: ', projectConfigPath, nconf.get()
		catch err
			debug err

	nconf.defaults store: Defaults
	module.exports.Store = Store = nconf.get()
	return Store
